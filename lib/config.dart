const url = 'http://10.0.2.2:5000/';
//Auth
//const register = "${url}auth/registration";
const register = "${url}users/addUserClient/";
const login = "${url}users/login";
const getuserbyid = "${url}users/getUserById";
//Todo
const storeTodo = "${url}todo/storeTodo";
const getTodo = "${url}todo/getUserTodoList";
const deleteTodoItem = "${url}todo/deleteTodo";
//maison
const storeMaison = "${url}maisons/addMaisonForClient/";
const getMaison = "${url}maisons/getMaisonsByClientId";
const deleteMaison = "${url}maisons/deleteMaisonById";

//espace
const addEspace = "${url}espaces/addEspaceForMaison";
const getEspace = "${url}espaces/getAllEspacesByIdMaison";
const deleteEspace = "${url}espaces/deleteEspaceById";
const updateEspace = "${url}espaces/updateEspace";
