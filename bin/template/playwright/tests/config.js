import pwconfig from '../playwright.config';

export const config = pwconfig;
export const defaultBrand = pwconfig.use.my.defaultBrand;
export const brand = pwconfig.use.my.brand;
// export const serverAll = brand || defaultBrand || process.env.ALL;
export const serverAll = process.env.ALL;
export const updateHar = !!process.env.HAR;

export const BASE_URL = serverAll ? `/${brand.substring(0, 1)}` : ''; // appends to URL from playwright config
export const PAGE_URL = `${BASE_URL}/`;
export const API_ALL = '**/*';
export const BASE_API = '**/channel-api/';
export const BASE_API_GLOB = `${BASE_API}**`;

export const VP_SMALL = { width: 1024, height: 768 };
export const VP_MEDIUM = { width: 1200, height: 1024 };
export const VP_LARGE = { width: 1920, height: 1200 };

export const J_HOME = `${PAGE_URL}#/?req=HM`;
export const J_FAQ = `${PAGE_URL}#/?req=FQ`;

export const brandedLogin = {
  [defaultBrand]: 'ABC123123',
};

export const UI = {
  home: {
    name: 'paul',
    age: '42',
  },
};

console.warn(`J_HOME:   ${J_HOME}`);
if (serverAll) {
  console.warn(
    `\n\nYou need to be running the App with 'yarn start:all' with brand=${brand} or process.env.ALL[=${process.env.ALL}] is in use.\n\n`,
  );
} else {
  console.warn(`\n\nYou need to be running the App with 'yarn start'\n\n`);
}
