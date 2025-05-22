document.addEventListener('DOMContentLoaded', function() {

    const dataZuzycieInput = document.getElementById('data');
    if (dataZuzycieInput) {
        const dzisiaj = new Date();
        const rok = dzisiaj.getFullYear();
        const miesiac = String(dzisiaj.getMonth() + 1).padStart(2, '0');
        const dzien = String(dzisiaj.getDate()).padStart(2, '0');
        dataZuzycieInput.value = `${rok}-${miesiac}-${dzien}`;
    }

    const dataDostawaInput = document.getElementById('data-dostawa');
    if (dataDostawaInput) {
        const dzisiaj = new Date();
        const rok = dzisiaj.getFullYear();
        const miesiac = String(dzisiaj.getMonth() + 1).padStart(2, '0');
        const dzien = String(dzisiaj.getDate()).padStart(2, '0');
        dataDostawaInput.value = `${rok}-${miesiac}-${dzien}`;
    }

    console.log('Fetching data from /api/dane...');
    fetch('http://localhost:3000/api/dane')
        .then(response => response.json())
        .then(data => {
            const daneKontener = document.getElementById('dane-kontener');
            let html = '<ul>';
            data.forEach(item => {
                html += `
                    <li>
                        ID: ${item.id_surowca}, 
                        Nazwa: ${item.nazwa}, 
                        jednostka zakupu: ${item.jednostka_zakupu} ${item.jednostka_miary}, 
                        Stan magazynowy: ${item.stan_magazynowy} ${item.jednostka_miary}
                    </li>`;
            });
            html += '</ul>';
            daneKontener.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania danych:', error));

    fetch('http://localhost:3000/api/zuzycie')
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            const zuzyciaKontener = document.getElementById('zuzycia-kontener');
            let html = '<ul>';
            data.forEach(item => {
                html += `
                    <li>
                        ID Surowca: ${item.id_surowca}, 
                        Nazwa: ${item.nazwa_surowca}, 
                        Zużycie: ${item.zuzycie}, 
                        Data: ${item.data}
                    </li>`;
            });
            html += '</ul>';
            zuzyciaKontener.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania zużyć:', error));

    fetch('http://localhost:3000/api/dostawy')
        .then(response => response.json())
        .then(data => {
            const dostawyKontener = document.getElementById('dostawy-kontener');
            let html = '<ul>';
            data.forEach(item => {
                html += `
                    <li>
                        ID Surowca: ${item.id_surowca}, 
                        Ilość: ${item.ilosc}, 
                        Data: ${item.data}
                    </li>`;
            });
            html += '</ul>';
            dostawyKontener.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania dostaw:', error));

    const zuzycieForm = document.getElementById('dodaj-zuzycie-form');
    zuzycieForm.addEventListener('submit', function(event) {
        event.preventDefault();

        const idSurowca = document.getElementById('id-surowca').value;
        const zuzycie = document.getElementById('zuzycie').value;
        const data = document.getElementById('data').value;

        const payload = { id_surowca: parseInt(idSurowca, 10), zuzycie: parseFloat(zuzycie), data };

        fetch('http://localhost:3000/api/zuzycie', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(response => response.json())
        .then(result => {
            alert('Zużycie zostało dodane pomyślnie!');
            zuzycieForm.reset();
            location.reload(); 
        })
        .catch(error => alert('Wystąpił błąd podczas dodawania zużycia.'));
    });

    const dostawaForm = document.getElementById('dodaj-dostawe-form');
    dostawaForm.addEventListener('submit', function(event) {
        event.preventDefault();

        const idSurowca = document.getElementById('id-surowca-dostawa').value;
        const ilosc = document.getElementById('ilosc-dostawa').value;
        const data = document.getElementById('data-dostawa').value;

        const payload = { id_surowca: parseInt(idSurowca, 10), ilosc: parseFloat(ilosc), data };

        fetch('http://localhost:3000/api/dostawy', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
        .then(response => response.json())
        .then(result => {
            alert('Dostawa została dodana pomyślnie!');
            dostawaForm.reset();
            location.reload(); 
        })
        .catch(error => alert('Wystąpił błąd podczas dodawania dostawy.'));
    });
});

function addRecord(table, data) {
    console.log(`Sending POST request to /api/${table} with data:`, data);
    fetch(`http://localhost:3000/api/${table}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => {
        console.log(`Response status: ${response.status}`);
        return response.json();
    })
    .then(result => console.log('Dodano rekord:', result))
    .catch(error => console.error('Błąd dodawania rekordu:', error));
}

function updateRecord(table, id, data) {
    console.log(`Updating record in ${table} with ID ${id}:`, data);
    fetch(`http://localhost:3000/api/${table}/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
    .then(response => {
        console.log(`Response status: ${response.status}`);
        if (!response.ok) {
            throw new Error('Błąd podczas aktualizacji rekordu');
        }
        return response.json();
    })
    .then(result => console.log('Zaktualizowano rekord:', result))
    .catch(error => console.error('Błąd aktualizacji rekordu:', error));
}

function deleteRecord(table, id) {
    console.log(`Deleting record from ${table} with ID ${id}`);
    fetch(`http://localhost:3000/api/${table}/${id}`, {
        method: 'DELETE'
    })
    .then(response => {
        console.log(`Response status: ${response.status}`);
        if (!response.ok) {
            throw new Error('Błąd podczas usuwania rekordu');
        }
        return response.json();
    })
    .then(result => console.log('Usunięto rekord:', result))
    .catch(error => console.error('Błąd usuwania rekordu:', error));
}
