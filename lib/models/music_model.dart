class MusicModel {
  int id;
  String title;
  String artist;
  String description;
  String photo;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.photo,
  });
}

List<MusicModel> musicList = [
  MusicModel(
    id: 1,
    title: "Title 1",
    artist: "Artist 1",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image1.jpeg",
  ),
  MusicModel(
    id: 2,
    title: "Title 2",
    artist: "Artist 2",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image2.jpeg",
  ),
  MusicModel(
    id: 3,
    title: "Title 3",
    artist: "Artist 3",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image3.jpeg",
  ),
  MusicModel(
    id: 4,
    title: "Title 4",
    artist: "Artist 4",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image4.jpeg",
  ),
  MusicModel(
    id: 5,
    title: "Title 5",
    artist: "Artist 5",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image5.jpeg",
  ),
  MusicModel(
    id: 6,
    title: "Title 6",
    artist: "Artist 6",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image6.jpeg",
  ),
  MusicModel(
    id: 7,
    title: "Title ",
    artist: "Artist 7",
    description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
    photo: "assets/images/album_image1.jpeg",
  ),
];
