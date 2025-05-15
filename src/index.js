import './styles.css';

import initial from "./homePage.js";
import loadMenu from './menuPage.js';
import loadAbout from './aboutPage.js';

initial();

const homeBtn = document.querySelector('button[aria-label="Go to Home page"]');
const menuBtn = document.querySelector('button[aria-label="Go to Menu page"]');
const aboutBtn = document.querySelector('button[aria-label="Learn more about us"]');
homeBtn.addEventListener('click', () => initial())
menuBtn.addEventListener('click', () => loadMenu())
aboutBtn.addEventListener('click', () => loadAbout());