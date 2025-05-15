import chefImage from './images/chef.jpg';

function loadAbout() {
    const content = document.getElementById("content");
    content.innerHTML = '';
    const head = document.createElement("h1");
    head.textContent = "All the BBQ. All on one plate. All good.";
    const p1 = document.createElement("p");
    const p2 = document.createElement("p");
    p1.textContent = `In order to form a more perfect BBQ, the 
        Federalist Pig is determined to bring all the best flavors together.`;
    p2.textContent = `Our menu is a walk around the country — and the world. 
        We’re paying homage to the American Southern traditions that first 
        inspired us, and the global traditions that made us curious. From fan 
        favorites, ribs, wings, brisket, and sausage to creative sandwiches to 
        captivating sides, you can find our inspo du jour — international, national,
         or something in between — front and center on our menu. The best way 
         to learn about us is to join us for a plate of BBQ.`;
    const image = document.createElement('img');
    image.src = chefImage;
    image.classList.add('about');
    content.appendChild(head);
    content.appendChild(p1);
    content.appendChild(p2);
    content.appendChild(image);
}

export default loadAbout;