![Badge](https://img.shields.io/static/v1?label=Rails&message=framework&color=red&style=for-the-badge&logo=rubyonrails)

<h1>Cadê Buffet?</h1>
<p align="justify"><i>Cadê Buffet?</i> is an application that aims to connect clients to companies that provide Buffet services.</p>
<h3>Features</h3>
<ul>
  <li>Authentication using Devise</li>
  <ul>
    <li> Sign up and log in as a User</li>
    <li> Sign up and log in as a Buffet Owner</li>
  </ul>
  <li>Register a Buffet as an Owner</li>
  <li>Add Event Types to a Buffet</li>
  <ul>
    <li>Set predefined prices for Events</li>
    <li>Add a cover photo to an Event</li>
  </ul>
  <li>List Buffets</li>
  <li>Search for Buffets by their names, associated Events, or locations</li>
  <li>Orders system</li>
  <ul>
    <li>User can order an Event by inputting date, guest quantity, and location</li>
    <li>Buffet Owner can evaluate an order and approve it by setting the price</li>
    <li>User can confirm the order if approved by the Buffet</li>
    <li>User and Buffet Owner can chat via the Order view page</li>
  </ul>
  <li>The app provides API endpoints that are further described below</li>
</ul>

API

if you run
```http://localhost:3000/api/v1/buffets```

you will receive as response an array containing the list of all buffets registered in the app, ordered by name:

```
[
  {
    "id": 3,
    "name": "Bons Momentos",
    "corporate_name": "Bons Momentos Buffet Ltda",
    "cnpj": "56473829100",
    "phone": "4198526374",
    "email": "atendimento@bonsmomentos.com.br",
    "address": "Praça da Estação, 45",
    "neighborhood": "Centro",
    "city": "Recife",
    "state": "PE",
    "zipcode": "52000123",
    "description": null,
    "pix": true,
    "debit": false,
    "credit": true,
    "cash": true,
    "owner_id": 3
  },
  {
    "id": 2,
    "name": "Celebra",
    "corporate_name": "Celebrações e Festas S.A.",
    "cnpj": "98765432109",
    "phone": "3197654321",
    "email": "celebra@celebra.com.br",
    "address": "Avenida dos Diamantes, 300",
    "neighborhood": "Industrial",
    "city": "Belo Horizonte",
    "state": "MG",
    "zipcode": "52000123",
    "description": null,
    "pix": false,
    "debit": true,
    "credit": true,
    "cash": true,
    "owner_id": 2
  },
  {
    "id": 1,
    "name": "Festim",
    "corporate_name": "Festim Eventos Ltda",
    "cnpj": "12345678901",
    "phone": "1198765432",
    "email": "contato@festim.com.br",
    "address": "Rua das Camélias, 58",
    "neighborhood": "Jardim",
    "city": "São Paulo",
    "state": "SP",
    "zipcode": "52000123",
    "description": null,
    "pix": true,
    "debit": true,
    "credit": true,
    "cash": false,
    "owner_id": 1
  }
]
```