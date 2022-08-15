class Product{
   final String name;
 final double price;
 final String imgUrl;

const Product({required this.name,required this.price,required this.imgUrl});

static const List<Product> products=[
  Product(
    name: 'Apple',
    price: 30,
    imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_SugarBee_Apple_now_grown_in_Washington_State.jpg/270px-The_SugarBee_Apple_now_grown_in_Washington_State.jpg'
  ),
   Product(
    name: 'Mango',
    price: 50,
    imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_SugarBee_Apple_now_grown_in_Washington_State.jpg/270px-The_SugarBee_Apple_now_grown_in_Washington_State.jpg'
  ),
   Product(
    name: 'Pineapple',
    price: 100,
    imgUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/The_SugarBee_Apple_now_grown_in_Washington_State.jpg/270px-The_SugarBee_Apple_now_grown_in_Washington_State.jpg'
  ),
];
}