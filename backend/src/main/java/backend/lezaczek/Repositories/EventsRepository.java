package backend.lezaczek.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import backend.lezaczek.Model.Event;

import java.sql.Date;
import java.util.List;

@Repository
public interface EventsRepository extends JpaRepository<Event, Long> {
    @Query(value = "SELECT *\r\n" + //
                "FROM Events\r\n" + //
                "WHERE UserId = :#{#userId}\r\n" + //
                "  AND (\r\n" + //
                "    -- Single Time Event\r\n" + //
                "    (EventType = 0 AND DateStart = :#{#dateSelected})\r\n" + //
                "\r\n" + //
                "    -- Daily Event\r\n" + //
                "    OR (EventType = 1 AND :#{#dateSelected} BETWEEN DateStart AND DateEnd)\r\n" + //
                "\r\n" + //
                "    -- Weekly Event\r\n" + //
                "    OR (EventType = 2 \r\n" + //
                "        AND :#{#dateSelected} BETWEEN DateStart AND DateEnd \r\n" + //
                "        AND DATEPART(WEEKDAY, DateStart) = DATEPART(WEEKDAY, :#{#dateSelected}))\r\n" + //
                "  ) order by startingTime", nativeQuery = true)
    List<Event> findByDateUserId(@Param("dateSelected") Date dateSelected,@Param("userId") int userId);

}

