//const url = 'http://10.0.2.2:5000/';
//192.168.100.106  wifi ooredoo*
//192.168.1.102  wifi NET
const url = 'http://192.168.100.106:5000/';
//Auth
//const register = "${url}auth/registration";
const register = "${url}users/addUserClient/";
const login = "${url}users/login";
const getuserbyid = "${url}users/getUserById";
const updateUserById =
    "${url}users/updateuserById"; // hethi mati5dimtchi b config url f controlller

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

const getCuisineByIdespace = "${url}cuisines/getCuisineByIdEspace";
const updateRelayByIdCuisine = "${url}cuisines/updateRelayByIdCuisine";
//wc
const getWccByIdEspace = "${url}wcs/getWcByIdEspace/";
const updateRelayByIdWc = "${url}wcs/updateRelayByIdWc";
//salon
const getSalonByIdEspace = "${url}salons/getSalonByIdEspace/";
const updateRelayByIdSalon = "${url}salons/updateRelayByIdSalon";
//chambre

const getChambreByIdEspace = "${url}chambres/getChambreByIdEspace";
const updateRelayByIdChambre = "${url}chambres/updateRelayByIdChambre";
//garage

const getPortGarageByIdClient = "${url}garages/getPortGarageByIdClient";
const updatePortGarageByIdGarage = "${url}garages/updatePortGarageByIdGarage";
