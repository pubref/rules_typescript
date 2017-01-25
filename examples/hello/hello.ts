//module SomeModule {
  export class RaceTrack {
    constructor(private host: Element) {
      host.appendChild(document.createElement("canvas"));
      console.log('Hello');
    }
  }
//}
