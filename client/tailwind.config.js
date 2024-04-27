/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: ['./src/**/*.{js,jsx}', 'node_modules/preline/dist/*.js'],
  theme: {
    fontFamily: {
      logo: ['Fjalla One'],
    },
    extend: {},
  },
  plugins: [require('preline/plugin')],
};
