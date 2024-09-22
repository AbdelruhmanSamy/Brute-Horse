/** @type {import('tailwindcss').Config} */

export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    fontFamily: {
      'header': ['"Rubik Glitch"'],
      'body': ['"Space Mono"'],
    },
    extend: {
      colors: {
        'regular-blue': '#003058',
        'light-blue':'#004C8B',
        'regular-grey': "#CCC5C5",
        'call-to-action':"#D99F0A",
        
      },
    },
  },
  plugins: [],
}

