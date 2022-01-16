

describe ('Test the feedback form', () => {
    Cypress.on('uncaught:exception', (err, runnable) => {
        return false
})
    it('Fill in the required fields in the feedback form with valid data', () => { 
        cy.visit('https://www.globalsqa.com/samplepagetest/'),
        cy.get('#g2599-name').type ('Test'),
        cy.get('#g2599-email').type ('test@ua.com'),
        cy.get('#g2599-experienceinyears').select('0-1'),
        cy.get('#contact-form-comment-g2599-comment').type ('Life is beautiful!'),
        cy.get('.pushbutton-wide').click()
        cy.get('#contact-form-2599 > h3').should('have.text', 'Message Sent (go back)');
    })
    it('Fill in all fields in the feedback form with valid data', () => {
        cy.visit('https://www.globalsqa.com/samplepagetest/'),
//        cy.get('.wpcf7-form-control').attachFile ('MyFoto'),
        cy.get('#g2599-name').type ('Test'),
        cy.get('#g2599-email').type ('test@ua.com'),
        cy.get('#g2599-website').type ('https://www.google.com'),
        cy.get(':nth-child(2) > .checkbox-multiple').click (),
        cy.get(':nth-child(4) > .checkbox-multiple').click (),
        cy.get(':nth-child(6) > .checkbox-multiple').click (),
        cy.get(':nth-child(2) > .radio').click (),
        cy.get('#g2599-experienceinyears').select('1-3'),
        cy.get('#contact-form-comment-g2599-comment').type ('La vita è bella!');
        cy.get('.pushbutton-wide').click(),
        cy.get('#contact-form-2599 > h3').should('have.text', 'Message Sent (go back)');
    })
    it('Fill in the required fields in the feedback form with valid data and empty the "Name" field', () => { 
        cy.visit('https://www.globalsqa.com/samplepagetest/'),
        cy.get('#g2599-email').type ('test@ua.com'),
        cy.get('#g2599-experienceinyears').select('0-1'),
        cy.get('#contact-form-comment-g2599-comment').type ('Life is beautiful!'),
        cy.get('.pushbutton-wide').click(),
        cy.get('input:invalid').should ('have.length', 1),
        cy.get('#g2599-name').then (($input)  => {
            expect($input[0].validationMessage)
        });
        cy.get('.pushbutton-wide').should ('be.visible');
    })    
    })