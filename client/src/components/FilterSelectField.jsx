import { useId } from 'react';

const FilterSelectField = ({
  name,
  displayName,
  options,
  searchFields,
  setSearchFields,
}) => {
  const id = useId();

  const handleValueChange = (event) => {
    setSearchFields({ ...searchFields, [name]: event.target.value });
  };

  return (
    <div>
      <label
        htmlFor={id}
        className="block text-sm font-medium mb-2 dark:text-white"
      >
        {displayName}
      </label>
      <select
        id={id}
        className="py-3 px-4 pr-9 block w-full border border-gray-200 rounded-md text-sm focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
        value={searchFields[name]}
        onChange={handleValueChange}
      >
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.displayValue}
          </option>
        ))}
      </select>
    </div>
  );
};

export default FilterSelectField;
