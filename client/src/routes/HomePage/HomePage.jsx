import { Link } from 'react-router-dom';

const HomePage = () => {
    return (
        <div className="grid gap-y-10 place-items-center">
            <h1 className="text-4xl font-bold mb-2 mt-60">BookBoard</h1>
                <Link className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded" to="/search">Get Started!</Link>
        </div>
    );
}

export default HomePage;
