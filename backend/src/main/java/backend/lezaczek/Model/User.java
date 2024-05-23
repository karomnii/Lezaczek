package backend.lezaczek.Model;

import java.io.Serializable;
import java.sql.Date;
import lombok.Getter;
import lombok.Setter;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

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
    @Getter @Setter private Gender userGender;

    public User() {}

    public User(String userId, String name, String email, String surname, int IsAdmin, Date timeCreated, Date lastLogin, String password, Gender userGender) {
        this.userId = Integer.parseInt(userId);
        this.name = name;
        this.email = email;
        this.surname = surname;
        this.IsAdmin = IsAdmin;
        this.timeCreated = timeCreated;
        this.lastLogin = lastLogin;
        this.password = password;
        this.userGender = userGender;

    }
    @Override
    public String toString() {
        return "{" +
                "userId:" + userId +
                ", name:'" + name + '\'' +
                ", email:'" + email + '\'' +
                ", surname:'" + surname + '\'' +
                ", IsAdmin:" + IsAdmin +
                ", timeCreated:" + timeCreated +
                ", lastLogin:" + lastLogin +
                ", password:'" + password + '\'' +
                ", userGender:" + userGender;
    }
}
