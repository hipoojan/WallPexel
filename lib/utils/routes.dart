const String API_KEY = "563492ad6f91700001000001a2a49e17a8414896929b79b14bc5feec";
const String BASE = "https://api.pexels.com/v1/";

String getWallpaperRoute(int page, int amount) => BASE + "curated?page=$page&per_page=$amount";
