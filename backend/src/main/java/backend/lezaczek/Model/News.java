package backend.lezaczek.Model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "News")
@Getter
@Setter
@ToString
public class News {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long newsId;
    private Long userId;
    private String name;
    private String description;
    private String place;
    private LocalDateTime dateAdded;
    private LocalDate dateOfEvent;
    private LocalTime startingTime;
    private LocalTime endingTime;

    public News() {}

    public News(Long newsId, Long userId, String name, String description,
                String place, LocalDateTime dateAdded, LocalDate dateOfEvent,
                LocalTime startingTime, LocalTime endingTime) {
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
  
    public News(String name, String description, String place,
                LocalDate dateOfEvent, LocalTime startingTime,
                LocalTime endingTime) {
        this.name = name;
        this.description = description;
        this.place = place;
        this.dateOfEvent = dateOfEvent;
        this.startingTime = startingTime;
        this.endingTime = endingTime;
    }
}