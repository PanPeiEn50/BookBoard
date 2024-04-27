const { create } = require("domain");
const readline = require("readline");
var fs = require("fs");
const { off } = require("process");

var isbn, workCount, authErr = 0;
var authorFirstName, authorSearchName = "";
var title, desc, authorLastName, authorbDay;
var fiction;
var writeStream, createStream;
let subjectData, workData, authorData, authorInfoData, editionData, querySize;


if(process.argv.length !== 5){

    console.log("Invalid Arguments.\nUsage: node bookBoardInsertion {subjectName} {desired number of input entries} {offset of entry list where '0' gathers entries from start of api list}");
    process.exit(1);

}

// process.argv.forEach(element => console.log(element));

let genre = process.argv[2];
let lim = parseInt(process.argv[3]);
let offsetFlag = parseInt(process.argv[4]);


if(!isNaN(parseInt(genre))){
    console.log("Invalid subject type, subject should be string literal.");
    process.exit(1);

}

if(isNaN(lim) || (lim < 0 || lim > 150)){
    console.log("Invalid entry number, entry number must be [0-150] integer.");
    process.exit(1);

}

if(isNaN(offsetFlag) || (offsetFlag < 0)){
    console.log("Invalid offset entry, offset must be positive integer")
    process.exit(1);

}

center();

async function subjectCall(){
    //Gather list of books by parsed subject
    const response = await fetch("http://openlibrary.org/subjects/"+genre+".json?limit="+querySize);
    subjectData = await response.json();

}

async function worksCall(workID){

    //Gather raw JSON for individual book data
    const responseWork = await fetch("http://openlibrary.org"+workID+".json");
    workData = await responseWork.json();

    //Gather raw JSON for edition information to gather ISBN
    const responseEdition = await fetch("http://openlibrary.org"+workID+"/editions.json");
    editionData = await responseEdition.json();

    //Gather raw JSON of author name information
    var authorID = workData.authors;
    try{
    var authorIDresponse = authorID[0].author.key;

    }catch(e){
        authErr = 1;
        return;
    }
    const responseAuthor = await fetch("http://openlibrary.org"+authorIDresponse+".json");
    authorData = await responseAuthor.json();

}

async function center(){
    var errLog = 0;

    if(!fs.existsSync(genre+".sql")){
        await (createStream = fs.createWriteStream(genre+".sql"));
        createStream.end();

    }

    writeStream = fs.createWriteStream(genre+".sql", {
        flags: 'a'
    });
    querySize = parseInt(offsetFlag) + parseInt(lim);

    await subjectCall();

    for(let i = offsetFlag; i < querySize; i++){

        try{
            title = (subjectData.works[i]).title;

        }catch(e){

            if(i == 0){
                console.log("Invalid subject entry.");
                process.exit(1);

            }else{
                break;

            }

        }

        await worksCall((subjectData.works[i]).key);

        if(authErr != 0){
            authErr = 0;
            errLog++;
            continue;

        }

        try{
            isbn = (editionData.entries[0]).isbn_13[0];
        }catch(e){
            errLog++;
            continue;

        }

        authorbDay = authorData.birth_date;
        if(authorbDay == undefined){
            errLog++;
            continue;

        }


        if(authorData.personal_name == undefined){
            errLog++;
            continue;

        }else{

            var authorName = authorData.personal_name.split(" ");
            authorLastName = authorName[authorName.length-1];

            if(authorName.length-1 == 0){
                authorFirstName = authorLastName;

            }else{
                authorFirstName = authorData.personal_name.substring(0, authorData.personal_name.lastIndexOf(" "));

            }

            //Format author name for author info query from split return
            for(let i = 0; i < authorName.length-1; i++){
                authorSearchName += authorName[i] + "%20";

            }
            authorSearchName += authorName[authorName.length-1];

            const responseAuthorInfo = await fetch("http://openlibrary.org/search/authors.json?q="+authorSearchName);
            authorInfoData = await responseAuthorInfo.json();
            authorSearchName = "";
            workCount = authorInfoData.docs[0].work_count;

        }

        desc = workData.description;
        if(typeof desc === "object" || desc == undefined){
            errLog++;
            continue;
        }

        var modDesc = desc.split("'");
        desc = "";
        for(let i = 0; i < modDesc.length; i++){
            desc += modDesc[i];

        }

        var modTitle = title.split("'");
        title = "";
        for(let i = 0; i < modTitle.length; i++){
            title += modTitle[i];

        }

        const worksSubj = workData.subjects;
        const fictFound = worksSubj.find((flag) => flag == "Fiction" || flag == "fiction");

        if(fictFound == undefined){
            fiction = false;

        }else{
            fiction = true;

        }

        writeStream.write("INSERT INTO books VALUES (DEFAULT, "+isbn+", \'"+title+"\', \'"+desc+"\', \'"+genre+"\', "+fiction+") ON CONFLICT DO NOTHING;\n");
        writeStream.write("INSERT INTO authors VALUES (DEFAULT, \'"+authorFirstName+"\', \'"+authorLastName+"\', \'"+authorbDay+"\', "+workCount+") ON CONFLICT DO NOTHING;\n");
        writeStream.write("INSERT INTO book_author SELECT b1.book_id, a1.author_id FROM (SELECT book_id FROM books WHERE title = \'"+title+"\') AS b1 CROSS JOIN (SELECT author_id FROM authors WHERE first_name = \'"+authorFirstName+"\' AND last_name = \'"+authorLastName+"\') AS a1 ON CONFLICT DO NOTHING;\n");

    }
    console.log("Num of Entries skipped due to missing API data: "+errLog);

    writeStream.end();


}
