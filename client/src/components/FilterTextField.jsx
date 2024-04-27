import { useId } from 'react';

const FilterTextField = ({
  name,
  displayName,
  searchFields,
  setSearchFields,
}) => {
  const id = useId();

  const handleValueChange = (event) => {
    let value = event.target.value;
    setSearchFields({ ...searchFields, [name]: value });
  };

  return (
    <div>
      <label
        htmlFor={id}
        className="block text-sm font-medium mb-2 dark:text-white"
      >
        {displayName}
      </label>
      <input
        type="email"
        id={id}
        className="border py-3 px-4 block w-full border-gray-200 rounded-md text-sm focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
        placeholder={displayName}
        value={searchFields[name]}
        onChange={handleValueChange}
      />
    </div>
  );
};

export default FilterTextField;
