package backend.lezaczek.Model;

import lombok.Getter;
import lombok.Setter;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "Session")
public class Session {
    @Getter @Setter @Id private int userId;
    @Getter @Setter private String token;

    @OneToOne
    @MapsId
    @JoinColumn(name ="userId")
    private User user;
    public Session() {}

    public Session(int userId, String token) {
        this.userId = userId;
        this.token = token;

    }
    @Override
    public String toString() {
        return "{" +
                "\"userId\":\"" + userId + "\"" +
                ", \"token\":\"" + token + "\"" +
                "}";
    }
}