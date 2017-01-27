export class App {
    constructor(private host: Element) {
        host.appendChild(document.createElement("div"));
        div.innerText = 'Hello';
        console.log('App initialized!');
    }

    toString(): string {
        return 'HelloApp';
    }

}
