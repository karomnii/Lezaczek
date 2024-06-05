package backend.lezaczek.Model;

import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.sql.Date;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import backend.lezaczek.HttpInterfaces.RegisterRequest;
import backend.lezaczek.Services.AuthService;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Component
@Table(name = "Users")
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class User implements Serializable {
    public enum Gender {
        MALE, FEMALE, OTHER
    };

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;
    private String name;
    private String email;
    private String surname;
    private int IsAdmin;
    private Date timeCreated;
    private Date lastLogin;
    private String password;
    private String salt;
    private Gender userGender;

    @Transient
    private User currentUser;

    public User(RegisterRequest req) {
        byte[] salt = AuthService.getSalt();
        this.email = req.getEmail();
        this.name = req.getName();
        this.surname = req.getSurname();
        this.password = new String(AuthService.hash(req.getPassword().toCharArray(), salt),
                StandardCharsets.ISO_8859_1);
        this.salt = new String(salt, StandardCharsets.ISO_8859_1);
        this.userGender = req.getGender();
    }

    // This method is used to send the user data to the frontend without the
    // password and salt
    @Override
    public String toString() {
        return "{" +
                "\"name\":\"" + name + "\"" +
                ", \"email\":\"" + email + "\"" +
                ", \"surname\":\"" + surname + "\"" +
                ", \"IsAdmin\":\"" + IsAdmin + "\"" +
                ", \"timeCreated\":\"" + timeCreated + "\"" +
                ", \"lastLogin\":\"" + lastLogin + "\"" +
                ", \"userGender\":\"" + userGender.ordinal() + "\"" + "}";
    }
}