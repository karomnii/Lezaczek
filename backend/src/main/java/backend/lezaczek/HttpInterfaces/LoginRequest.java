package backend.lezaczek.HttpInterfaces;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class LoginRequest extends Request<String, Object> {
    private String email;
    private String password;

}