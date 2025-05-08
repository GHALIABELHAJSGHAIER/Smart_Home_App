//const url = 'http://10.0.2.2:5000/';
//192.168.0.79
const url = 'http://192.168.100.106:5000/';
//Auth
//const register = "${url}auth/registration";
const register = "${url}users/addUserClient/";
const login = "${url}users/login";
const getuserbyid = "${url}users/getUserById";

//maison
const addMaison = "${url}maisons/addMaisonForClient";
const getMaison = "${url}maisons/getMaisonsByClientId";
const deletemaison = "${url}maisons/deleteMaisonById";
const updatemaison = "${url}maisons/updateMaison";

//espace
const addEspace = "${url}espaces/addEspaceForMaison";
const getEspace = "${url}espaces/getAllEspacesByIdMaison";
const deleteespace = "${url}espaces/deleteEspaceById";
const updateespace = "${url}espaces/updateEspace";
//gemini
const gemini = "${url}gemini/generate";
//cuisine
const addCuisine = "${url}espaces/addEspaceForMaison";
const getRelayCuisine = "${url}cuisines/getRelay";
const updatecuisine = "${url}cuisines/updateCuisine";
/////
//const updateRelayById = "${url}cuisines/updateRelay";
//const getCuisineById = "${url}cuisines/getCuisineById";
const getCuisineByIdespace = "${url}cuisines/getCuisineByIdEspace";
//const deleteespace = "${url}espaces/deleteEspaceById";
