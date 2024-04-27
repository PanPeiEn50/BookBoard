export const API_BASE_URL = 'http://localhost:3001';

export const ISBN_REGEX = /^\d{13}$/;

export const SORT_OPTIONS = [
  {
    text: 'Title ↓',
    value: 'title-asc',
  },
  {
    text: 'Title ↑',
    value: 'title-desc',
  },
  {
    text: 'Genre ↓',
    value: 'genre-desc',
  },
  {
    text: 'Genre ↑',
    value: 'genre-asc',
  },
  {
    text: 'Author ↓',
    value: 'author-desc',
  },
  {
    text: 'Author ↑',
    value: 'author-asc',
  },
  {
    text: 'Rating ↓',
    value: 'avgRating-desc',
  },
  {
    text: 'Rating ↑',
    value: 'avgRating-asc',
  },
];

export const RESULTS_PER_PAGE_OPTIONS = [
  {
    text: '25',
    value: '25',
  },
  {
    text: '50',
    value: '50',
  },
  {
    text: '75',
    value: '75',
  },
  {
    text: '100',
    value: '100',
  },
];

export const FICTION_OPTIONS = [
  {
    value: 'any',
    displayValue: 'Any',
  },
  {
    value: 'true',
    displayValue: 'Yes',
  },
  {
    value: 'false',
    displayValue: 'No',
  },
];

export const AVERAGE_RATING_OPTIONS = [
  {
    value: 'any',
    displayValue: 'Any',
  },
  {
    value: '4',
    displayValue: '4+ ★',
  },
  {
    value: '3',
    displayValue: '3+ ★',
  },
  {
    value: '2',
    displayValue: '2+ ★',
  },
  {
    value: '1',
    displayValue: '1+ ★',
  },
];

export const DEFAULT_SEARCH_FIELDS = {
  titleOrIsbn: '',
  authors: [],
  genres: [],
  fiction: FICTION_OPTIONS[0].value,
  avgRating: AVERAGE_RATING_OPTIONS[0].value,
  sortBy: SORT_OPTIONS[0].value,
  resultsPerPage: RESULTS_PER_PAGE_OPTIONS[0].value,
  page: 0,
};
