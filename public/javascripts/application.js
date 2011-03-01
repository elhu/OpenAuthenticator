$(document).ready(function () {
    $("#new_user").validate({
        rules: {
            "user[first_name]": {required: true, maxlength: 50},
            "user[last_name]": {required: true, maxlength: 50},
            "user[login]": {required: true, maxlength: 25, remote: "/users/new/check_login.json"},
            "user[email]": {required: true, email: true, remote: "/users/new/check_email.json"}
        },
        messages: {
            "user[first_name]": {
                required: "Le prenom est obligatoire",
                maxlength: jQuery.format("Votre prenom ne peut pas exceder {0} caracteres")
            },
            "user[last_name]": {
                required: "Le nom est obligatoire",
                maxlength: jQuery.format("Votre nom ne peut pas exceder {0} caracteres")
            },
            "user[login]": {
                required: "Le nom d'utilisateur est obligatoire",
                maxlength: jQuery.format("Votre nom d'utilisateur ne peux pas exceder {0} caracteres"),
                remote: jQuery.format("Le nom d'utilisateur {0} n'est pas disponible")
            },
            "user[email]": {
                required: "L'email est obligatoire",
                email: "Votre email n'est pas au bon format",
                remote: jQuery.format("Un compte utilisant l'adresse {0} existe deja")
            },
            "user[password]": {
                required: "Le mot de passe est obligatoire",
                minlength: jQuery.format("Le mot de passe doit etre long d'au moins {0} caracteres")
            },
            "user[password_confirmation]": {
                required: "La confirmation du mot de passe est obligatoire",
                equalTo: "Les deux mots de passe doivent etre identique"
            }
        }
    });
});