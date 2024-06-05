package backend.lezaczek.HttpInterfaces;

import backend.lezaczek.Model.User.Gender;
import lombok.Getter;
import lombok.Setter;

public class RegisterRequest extends Request<String, Object> {
    @Getter
    @Setter
    private String email;
    @Getter
    @Setter
    private String password;
    @Getter
    @Setter
    private String name;
    @Getter
    @Setter
    private String surname;
    @Getter
    @Setter
    private Gender gender;

    public RegisterRequest() {
    };

    public RegisterRequest(String email, String password, String name, String surname, Gender gender) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.surname = surname;
        this.gender = gender;
    }
}