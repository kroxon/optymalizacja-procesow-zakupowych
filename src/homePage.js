function initial() {
    const content = document.getElementById("content");
    content.innerHTML = '';
    const title = document.createElement("h1");
    title.textContent = "Welcome to Our Restaurant!";
    const description1 = document.createElement("p");
    const description2 = document.createElement("p");
    description1.textContent = "At Our Restaurant, we pride ourselves on serving the freshest \
     ingredients and creating mouth-watering dishes that delight your taste buds. Whether you're \
     here for a special occasion or just a casual dinner, we ensure an unforgettable dining experience." ;
    description2.textContent = "Join us and enjoy our cozy atmosphere, exceptional service, and a menu that has something for everyone!";
    content.appendChild(title);
    content.appendChild(description1);
    content.appendChild(description2);
}

export default initial;