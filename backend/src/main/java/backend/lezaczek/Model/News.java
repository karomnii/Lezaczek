package backend.lezaczek.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "News")
@Getter
@Setter
@ToString
public class News {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private int newsId;
    private int userId;
    private String name;
    private String description;
    private String place;
    private LocalDate dateAdded;
    private LocalDate dateOfEvent;
    private LocalTime startingTime;
    private LocalTime endingTime;

    public News() {}

    public News(int newsId, int userId, String name, String description,
                String place, LocalDate dateAdded, LocalDate dateOfEvent, LocalTime startingTime,
                LocalTime endingTime) {
        this.newsId = newsId;
        this.userId = userId;
        this.name = name;
        this.description = description;
        this.place = place;
        this.dateAdded = dateAdded;
        this.dateOfEvent = dateOfEvent;
        this.startingTime = startingTime;
        this.endingTime = endingTime;
    }
}
