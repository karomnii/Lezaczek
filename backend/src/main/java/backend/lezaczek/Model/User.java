package backend.lezaczek.Model;

import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.sql.Date;

import backend.lezaczek.HttpInterfaces.RegisterRequest;
import backend.lezaczek.Services.AuthService;
import lombok.Getter;
import lombok.Setter;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

// @Getter
// @Setter
// @ToString
@Entity
@Table(name = "Users")
public class User implements Serializable {
    public enum Gender {MALE, FEMALE, OTHER};
    @Getter @Setter @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private int userId;
    @Getter @Setter private String name;
    @Getter @Setter private String email;
    @Getter @Setter private String surname;
    @Getter @Setter private int IsAdmin;
    @Getter @Setter private Date timeCreated;
    @Getter @Setter private Date lastLogin;
    @Getter @Setter private String password;
    @Getter @Setter private String salt;
    @Getter @Setter private Gender userGender;

    public User() {}

    public User(RegisterRequest req) {
        byte[] salt = AuthService.getSalt();
        this.email = req.getEmail();
        this.name = req.getName();
        this.surname = req.getSurname();
        this.password = new String(AuthService.hash(req.getPassword().toCharArray(), salt), StandardCharsets.ISO_8859_1);
        this.salt = new String(salt, StandardCharsets.ISO_8859_1);
        this.userGender = req.getGender();
    }
    public User(String userId, String name, String email, String surname, int IsAdmin, Date timeCreated, Date lastLogin, String password, String salt, Gender userGender) {
        this.userId = Integer.parseInt(userId);
        this.name = name;
        this.email = email;
        this.surname = surname;
        this.IsAdmin = IsAdmin;
        this.timeCreated = timeCreated;
        this.lastLogin = lastLogin;
        this.password = password;
        this.userGender = userGender;
        this.salt = salt;
    }
    @Override
    public String toString() {
        return "{" +
                "\"userId\":\"" + userId + "\"" +
                ", \"name\":\"" + name + "\"" +
                ", \"email\":\"" + email + "\"" +
                ", \"surname\":\"" + surname + "\"" +
                ", \"IsAdmin\":\"" + IsAdmin + "\"" +
                ", \"timeCreated\":\"" + timeCreated + "\"" +
                ", \"lastLogin\":\"" + lastLogin + "\"" +
                ", \"userGender\":\"" + userGender + "\"" + "}";
    }
}