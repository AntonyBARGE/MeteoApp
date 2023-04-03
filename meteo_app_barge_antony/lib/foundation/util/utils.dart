String getAssetFromWeatherCode(int weatherCode){
  switch (weatherCode) {
    case 0:
      return 'clearsky.png';
    case 1:
    case 2:
    case 3:
      return 'partlycloudy.png';
    case 45:
    case 48:
      return 'cloudy.png';
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return 'drizzle.png';
    case 61:
    case 63:
    case 65:
      return 'rain.png';
    case 66:
    case 67:
      return 'freezingrain.png';
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return 'snowfall.png';
    case 80:
    case 81:
    case 82:
      return 'rainshower.png';
    case 95:
    case 96:
    case 99:
      return 'thunder.png';
    default:
      return 'cloud.png';
  }
}