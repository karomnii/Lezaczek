package backend.lezaczek.Model;

import java.io.Serializable;
import java.sql.Time;
import java.sql.Date;
import java.sql.Timestamp;
import lombok.Getter;
import lombok.Setter;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Events")
public class Event implements Serializable {
    public enum EventType {SINGLE, DAILY, WEEKLY}
    @Getter @Setter @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private int eventId;
    @Getter @Setter private int userID;
    @Getter @Setter private String name;
    @Getter @Setter private String description;
    @Getter @Setter private int place;
    @Getter @Setter private EventType eventType;
    @Getter @Setter private Timestamp dateAdded;
    @Getter @Setter private Date dateStart;
    @Getter @Setter private Date dateEnd;
    @Getter @Setter private Time startingTime;
    @Getter @Setter private Time endingTime;

    public Event() {}

    public Event(String eventId, int userID, String name, String description, int place,EventType eventType, Timestamp dateAdded, Date dateStart, Date dateEnd, Time startingTime, Time endingTime) {
        this.eventId = Integer.parseInt(eventId);
        this.userID = userID;
        this.name = name;
        this.description = description;
        this.place = place;
        this.eventType = eventType;
        this.dateAdded = dateAdded;
        this.dateStart = dateStart;
        this.dateEnd = dateEnd;
        this.startingTime = startingTime;
        this.endingTime = endingTime;

    }
    @Override
    public String toString() {
        return "{" +
                "eventId:" + eventId +
                ", userID:'" + userID + '\'' +
                ", name:'" + name + '\'' +
                ", description:'" + description + '\'' +
                ", place:" + place +
                ", eventType:" + eventType +
                ", dateAdded:" + dateAdded +
                ", dateStart:" + dateStart +
                ", startingTime:'" + startingTime + '\'' +
                ", endingTime:" + endingTime;
    }
}
