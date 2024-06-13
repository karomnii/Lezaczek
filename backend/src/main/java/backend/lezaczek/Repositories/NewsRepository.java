package backend.lezaczek.Repositories;

import backend.lezaczek.Model.News;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NewsRepository extends JpaRepository<News, Long> {
    Optional<News> findNewsByName(String newsName);
    List<News> findAllByOrderByDateOfEventAscStartingTimeAsc();
    void deleteNewsByNewsId(Long newsId);
}
