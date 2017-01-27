//import 'mocha';
//import { expect } from 'chai';
//import { App } from './app';

describe('App', () => {
    it('should return correct app name', () => {
        const app = new App();
        expect(app.toString()).to.equal('HelloApp');
    });
});
