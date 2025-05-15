import pizzaImage from './images/pizza.jpg';
import burgerImage from './images/burger.jpg';
import pastaImage from './images/pasta.jpg';
import saladImage from './images/salad.jpg';

const items = [
    {
        name: "Margherita Pizza",
        alt: "Pizza",
        description: "Classic pizza with tomatoes, mozzarella, and fresh basil.",
        price: "$14.99",
        src: pizzaImage
    },
    {
        name: "Cheeseburger",
        alt: "Cheeseburger",
        description: "Juicy beef patty with cheddar cheese, lettuce, and tomato.",
        price: "$10.99",
        src: burgerImage
    },
    {
        name: "Spaghetti Carbonara",
        alt: "Spaghetti Carbonara",
        description: "Classic Italian pasta with bacon, parmesan, and egg.",
        price: "$14.99",
        src: pastaImage
    },
    {
        name: "Caesar Salad",
        alt: "Caesar Salad",
        description: "Crispy romaine lettuce, croutons, parmesan, and Caesar dressing.",
        price: "$9.99",
        src: saladImage
    },
    
    
];

function loadMenu() {
    const content = document.getElementById("content");
    content.innerHTML = '';
    const dish = document.createElement('div'); 
    dish.classList.add('menu-section');
    items.forEach(item => createMenuItem(dish, item));

    // double items
    items.forEach(item => createMenuItem(dish, item));

    content.appendChild(dish);
}

function createMenuItem(parent, item) {
    const menuItem = document.createElement('div');
    menuItem.classList.add('menu-item');

    const image = document.createElement('img');
    image.src = item.src;
    image.alt = item.alt;

    const title = document.createElement('h3');
    title.textContent = item.name;

    const description = document.createElement('p');
    description.textContent = item.description;

    const price = document.createElement('p');
    price.textContent = item.price;
    price.classList.add("price");

    menuItem.appendChild(image);
    menuItem.appendChild(title);
    menuItem.appendChild(description);
    menuItem.appendChild(price);

    parent.appendChild(menuItem);
}

export default loadMenu;