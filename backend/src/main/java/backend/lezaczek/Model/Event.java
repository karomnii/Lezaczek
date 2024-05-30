package backend.lezaczek.Model;

import java.io.Serializable;
import java.sql.Time;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;


@Entity
@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "Events")
public class Event implements Serializable {
    public enum EventType {SINGLE, DAILY, WEEKLY}

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int eventId;
    private int userID;
    private String name;
    private String description;
    private String place;
    private EventType eventType;
    @JsonFormat(pattern="yyyy-MM-dd")
    private Date dateStart;
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date dateEnd;
    private Time startingTime;
    private Time endingTime;
}
