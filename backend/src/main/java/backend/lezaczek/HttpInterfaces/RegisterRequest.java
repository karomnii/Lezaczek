package backend.lezaczek.HttpInterfaces;

import backend.lezaczek.Model.User.Gender;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest extends Request<String, Object> {
    private String email;
    private String password;
    private String name;
    private String surname;
    private Gender gender;

}