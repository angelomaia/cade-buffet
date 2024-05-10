![Badge](https://img.shields.io/static/v1?label=Ruby&message=back-end&color=red&style=for-the-badge&logo=ruby)
![Badge](https://img.shields.io/static/v1?label=Rails&message=framework&color=orange&style=for-the-badge&logo=rubyonrails)
![Badge](https://img.shields.io/static/v1?label=Bootstrap&message=front-end&color=blue&style=for-the-badge&logo=bootstrap)

<h1>Cadê Buffet?</h1>
<p align="justify"><i>Cadê Buffet?</i> is an application that aims to connect clients to companies that provide Buffet services.</p>
<h2>Features</h2>
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

<h2>API Documentation</h2>

The main API endpoint is a list of all Buffets registered in the app, and can be accessed by:<br>
```
http://localhost:3000/api/v1/buffets
```

This path returns an array containing the list of all Buffets registered in the app ordered by name:

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
Attributes:<br>
```id``` <i>integer</i> : the ID of the Buffet object in the Database<br>
```name``` <i>string</i> : the Name of the Buffet<br>
```corporate_name``` <i>string</i> : the legal name of the Buffet<br>
```cnpj``` <i>string</i> : the registration number of the Buffet<br>
```phone``` <i>string</i> : the phone of the Buffet<br>
```email``` <i>string</i> : the email of the Buffet<br>
```address``` <i>string</i> : the street address of where the Buffet is located<br>
```city``` <i>string</i> : the city in which the Buffet is located<br>
```state``` <i>string</i> : the state in which the Buffet is located<br>
```zipcode``` <i>string</i> : the zipcode of the location<br>
```description``` <i>string</i> : a brief description of the Buffet<br>
```pix``` <i>boolean</i> : defines whether the Buffet accepts PIX as the payment method<br>
```debit``` <i>boolean</i> : defines whether the Buffet accepts debit card as the payment method<br>
```credit``` <i>boolean</i> : defines whether the Buffet accepts credit card as the payment method<br>
```cash``` <i>boolean</i> : defines whether the Buffet accepts cash as the payment method<br>
```owner_id``` <i>integer</i> : the ID of the owner (devise model object) which the Buffet belongs to<br>
<br>
Details of a Buffet can also be accessed by ID:<br>
```
http://localhost:3000/api/v1/buffets/1
```

This path returns a list of details from the Buffet with ID == 1:
```
{
  "id": 1,
  "name": "Festim",
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
```
<br>
The Event types associated with a Buffet can also be retrieved:<br>
```http://localhost:3000/api/v1/buffets/1/event_types```

This path returns an array containing all Event Types associated with the Buffet with ID == 1:<br>
```
[
  {
    "id": 1,
    "name": "Festa de Casamento",
    "description": "Festa completa",
    "min_people": "20",
    "max_people": "100",
    "duration": "240",
    "menu": "Sushi, mesa de frios, strogonoff",
    "alcohol": null,
    "decoration": null,
    "parking": null,
    "location": "exclusive",
    "buffet_id": 1,
    "price": {
      "id": 1,
      "base": 5000,
      "extra_person": 200,
      "extra_hour": 1500,
      "weekend_base": null,
      "weekend_extra_person": null,
      "weekend_extra_hour": null,
      "event_type_id": 1
    }
  },
  {
    "id": 2,
    "name": "Festa Infantil",
    "description": "Festa completa",
    "min_people": "10",
    "max_people": "100",
    "duration": "240",
    "menu": "Sushi, mesa de frios, strogonoff",
    "alcohol": null,
    "decoration": null,
    "parking": null,
    "location": "anywhere",
    "buffet_id": 1
  }
]
```
Attributes:<br>
```id``` <i>integer</i> : the ID of the EventType object in the Database<br>
```name``` <i>string</i> : the Name of the Event<br>
```description``` <i>string</i> : a brief description of the Event<br>
```min_people``` <i>string</i> : the minimum number of people, used to set the base price of the Event<br>
```max_people``` <i>string</i> : the maximum number of people that the Event can provide for<br>
```duration``` <i>string</i> : the duration of the Event in minutes<br>
```menu``` <i>string</i> : a freely described menu for the Event<br>
```alcohol``` <i>boolean</i> : defines whether the Event provides alcoholic beverages<br>
```decoration``` <i>boolean</i> : defines whether the Event provides decoration service<br>
```parking``` <i>boolean</i> : defines whether the Event provide parking or valet services<br>
```buffet_id``` <i>integer</i> : the ID of the Buffet which the Event belongs to<br>
```price``` <i>Child Object</i> : an object that belongs_to the EventType, which has_one Price<br>
‎ ‎ ‎ ```price.id``` <i>integer</i> : the ID of the EventType object in the Database<br>
‎ ‎ ‎ ```price.base``` <i>float</i> : the base Price for the event, based on the duration and the min_people<br>
‎ ‎ ‎ ```price.extra_person``` <i>float</i> : additional value per extra person on the min_people quantity<br>
‎ ‎ ‎ ```price.extra_hour``` <i>float</i> : additional value per extra hour on the Event duration<br>
‎ ‎ ‎ ```price.weekend_base``` <i>float</i> : base price for weekends<br>
‎ ‎ ‎ ```price.weekend_extra_person``` <i>float</i> : weekend additional value per extra person on the min_people quantity<br>
‎ ‎ ‎ ```price.weekend_extra_hour``` <i>float</i> : weekend additional value per extra hour on the Event duration<br>
‎ ‎ ‎ ```price.event_type_id``` <i>integer</i> : the ID of the EventType which the Price belongs to<br>
<br>
An endpoint to check the availability of an event is also provided:
```
http://localhost:3000/api/v1/availability_check
```

However, three params need to be passed to the URL: a Date (date), the guest quantity (guests), and the ID of the EventType object (event_type_id):
```
http://localhost:3000/api/v1/availability_check?date=2024-12-12&guests=50&event_type_id=1
```

If the date is available (that is, the Buffet has no Event approved OR confirmed for the date AND the guest quantity is equal or less the maximum number of people that the Event can serve), the response should be the expected price of the event:
```
{
  "price": 11000
}
```

If the data is unavailable, the response should be a warnings array containing one string:
```
{
  "warnings": [
    "O Buffet já possui um evento marcado para esta data."
  ]
}
```

If the guest quantity is higher than the max_people attribute of the EventType object, the response should be a warnings array containing one string:
```
{
  "warnings": [
    "Quantidade de convidados acima do limite."
  ]
}
```



