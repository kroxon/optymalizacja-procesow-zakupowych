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

    // Helper function to format dates
    const formatDate = (dateString) => {
        const date = new Date(dateString);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}.${month}.${year}`;
    };

    // Populate "Dane o stanie magazynowym surowców"
    fetch('http://localhost:3000/api/dane')
        .then(response => response.json())
        .then(data => {
            const daneTabela = document.getElementById('dane-tabela');
            let html = '<thead><tr><th>ID</th><th>Nazwa</th><th>Jednostka Zakupu</th><th>Stan Magazynowy</th></tr></thead><tbody>';
            data.forEach(item => {
                html += `
                    <tr>
                        <td>${item.id_surowca}</td>
                        <td>${item.nazwa}</td>
                        <td>${item.jednostka_zakupu} ${item.jednostka_miary}</td>
                        <td>${item.stan_magazynowy} ${item.jednostka_miary}</td>
                    </tr>`;
            });
            html += '</tbody>';
            daneTabela.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania danych:', error));

    // Populate "Lista Zużyć"
    fetch('http://localhost:3000/api/zuzycie')
        .then(response => response.json())
        .then(data => {
            const zuzyciaTabela = document.getElementById('zuzycia-tabela');
            let html = '<thead><tr><th>ID Surowca</th><th>Nazwa</th><th>Zużycie</th><th>Data</th></tr></thead><tbody>';
            data.forEach(item => {
                html += `
                    <tr>
                        <td>${item.id_surowca}</td>
                        <td>${item.nazwa_surowca}</td>
                        <td>${item.zuzycie}</td>
                        <td>${formatDate(item.data)}</td>
                    </tr>`;
            });
            html += '</tbody>';
            zuzyciaTabela.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania zużyć:', error));

    // Populate "Lista Dostaw"
    fetch('http://localhost:3000/api/dostawy')
        .then(response => response.json())
        .then(data => {
            const dostawyTabela = document.getElementById('dostawy-tabela');
            let html = '<thead><tr><th>ID Surowca</th><th>Nazwa</th><th>Ilość</th><th>Data</th></tr></thead><tbody>';
            data.forEach(item => {
                html += `
                    <tr>
                        <td>${item.id_surowca}</td>
                        <td>${item.nazwa_surowca}</td>
                        <td>${item.ilosc}</td>
                        <td>${formatDate(item.data)}</td>
                    </tr>`;
            });
            html += '</tbody>';
            dostawyTabela.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania dostaw:', error));

    // Populate "Dni do minimalnego stanu"
    fetch('http://localhost:3000/api/surowce/days')
        .then(response => response.json())
        .then(data => {
            const dniTabela = document.getElementById('dni-tabela');
            let html = '<thead><tr><th>Surowiec</th><th>Obecny Stan</th><th>Minimalny Stan</th><th>Średnie Zużycie Dzienne</th><th>Dni do Minimalnego Stanu</th></tr></thead><tbody>';
            data.forEach(item => {
                html += `
                    <tr>
                        <td>${item.surowiec}</td>
                        <td>${item.obecny_stan_magazynowy}</td>
                        <td>${item.minimalny_stan_dopuszczalny}</td>
                        <td>${item.srednie_zuzycie_dzienne}</td>
                        <td>${item.dni_do_minimalnego_stanu_lub_zero}</td>
                    </tr>`;
            });
            html += '</tbody>';
            dniTabela.innerHTML = html;
        })
        .catch(error => console.error('Błąd pobierania danych o dniach:', error));

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

    const surowiecForm = document.getElementById('dodaj-surowiec-form');
    surowiecForm.addEventListener('submit', function(event) {
        event.preventDefault();

        const nazwa = document.getElementById('nazwa-surowca').value;
        const jednostkaZakupu = document.getElementById('jednostka-zakupu').value;
        const jednostkaMiary = document.getElementById('jednostka-miary').value;

        const payload = {
            nazwa,
            jednostka_zakupu: parseFloat(jednostkaZakupu),
            jednostka_miary: jednostkaMiary,
        };

        fetch('http://localhost:3000/api/surowce/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload),
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(result => {
            alert('Surowiec został dodany pomyślnie!');
            surowiecForm.reset();
            location.reload(); 
        })
        .catch(error => {
            alert('Wystąpił błąd podczas dodawania surowca.');
        });
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
