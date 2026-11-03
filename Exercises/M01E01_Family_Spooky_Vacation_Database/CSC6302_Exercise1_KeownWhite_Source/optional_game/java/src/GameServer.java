import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.Scanner;

public class GameServer {

        private static final String DB_URL = "jdbc:mysql://localhost:3306/FamilySpookyVacation";

        private static final String DB_USER = "root";

        private static String dbPassword;

        public static void main(String[] args) throws Exception {

                dbPassword = readPassword();

                try (Connection connection = getConnection()) {
                        System.out.println("Connected to FamilySpookyVacation.");
                }

                HttpServer server = HttpServer.create(
                                new InetSocketAddress(8080),
                                0);

                // =====================================================
                // FRONTEND
                // =====================================================

                server.createContext(
                                "/",
                                GameServer::handleHome);

                // =====================================================
                // READ API
                // =====================================================

                server.createContext(
                                "/api/health",
                                GameServer::handleHealth);

                server.createContext(
                                "/api/dashboard",
                                GameServer::handleDashboard);

                server.createContext(
                                "/api/options",
                                GameServer::handleOptions);

                // =====================================================
                // GAME ACTION API
                // =====================================================

                server.createContext(
                                "/api/activity",
                                GameServer::handleActivity);

                server.createContext(
                                "/api/contact",
                                GameServer::handleContact);

                server.createContext(
                                "/api/investigate",
                                GameServer::handleInvestigate);

                server.createContext(
                                "/api/accuse",
                                GameServer::handleAccuse);

                server.createContext(
                                "/api/advance",
                                GameServer::handleAdvance);

                server.setExecutor(null);
                server.start();

                System.out.println();
                System.out.println("Paranormal Expedition backend running.");
                System.out.println("Home:      http://localhost:8080");
                System.out.println("Health:    http://localhost:8080/api/health");
                System.out.println("Dashboard: http://localhost:8080/api/dashboard?session=1");
                System.out.println();
        }

        // =========================================================
        // PASSWORD
        // =========================================================

        private static String readPassword() {

                if (System.console() != null) {

                        char[] passwordChars = System.console().readPassword(
                                        "MySQL root password: ");

                        return new String(passwordChars);
                }

                Scanner scanner = new Scanner(System.in);

                System.out.print(
                                "MySQL root password: ");

                return scanner.nextLine();
        }

        // =========================================================
        // FRONTEND
        // =========================================================

        private static void handleHome(
                        HttpExchange exchange) throws IOException {

                Path frontend = Path.of(
                                "Exercises",
                                "M01E01_Family_Spooky_Vacation_Database",
                                "extension",
                                "frontend",
                                "index.html");

                if (!Files.exists(frontend)) {

                        send(
                                        exchange,
                                        404,
                                        "text/plain; charset=UTF-8",
                                        "Frontend file not found.");

                        return;
                }

                String html = Files.readString(
                                frontend,
                                StandardCharsets.UTF_8);

                send(
                                exchange,
                                200,
                                "text/html; charset=UTF-8",
                                html);
        }

        // =========================================================
        // HEALTH
        // =========================================================

        private static void handleHealth(
                        HttpExchange exchange) throws IOException {

                try (
                                Connection connection = getConnection();

                                Statement statement = connection.createStatement();

                                ResultSet result = statement.executeQuery(
                                                """
                                                                SELECT
                                                                    VERSION(),
                                                                    DATABASE()
                                                                """)) {

                        result.next();

                        String json = """
                                        {
                                          "status":"ok",
                                          "mysqlVersion":"%s",
                                          "database":"%s"
                                        }
                                        """.formatted(
                                        escapeJson(
                                                        result.getString(1)),
                                        escapeJson(
                                                        result.getString(2)));

                        sendJson(
                                        exchange,
                                        200,
                                        json);

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        500,
                                        e.getMessage());
                }
        }

        // =========================================================
        // DASHBOARD
        // =========================================================

        private static void handleDashboard(
                        HttpExchange exchange) throws IOException {

                int sessionId;

                try {

                        sessionId = getSessionId(
                                        exchange);

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid session ID.");

                        return;
                }

                try (
                                Connection connection = getConnection()) {

                        int currentTurn;
                        String startedAt;
                        String gameStatus;
                        int playerCount;

                        // -------------------------------------------------
                        // SESSION
                        // -------------------------------------------------

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            StartedAt,
                                                                            CurrentTurn,
                                                                            GameStatus,
                                                                            PlayerCount
                                                                        FROM vw_session_status
                                                                        WHERE SessionID = ?
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        if (!result.next()) {

                                                sendError(
                                                                exchange,
                                                                404,
                                                                "Game session not found.");

                                                return;
                                        }

                                        Timestamp started = result.getTimestamp(
                                                        "StartedAt");

                                        startedAt = started == null
                                                        ? ""
                                                        : started.toString();

                                        currentTurn = result.getInt(
                                                        "CurrentTurn");

                                        gameStatus = result.getString(
                                                        "GameStatus");

                                        playerCount = result.getInt(
                                                        "PlayerCount");
                                }
                        }

                        StringBuilder json = new StringBuilder();

                        json.append("{");

                        // -------------------------------------------------
                        // SESSION JSON
                        // -------------------------------------------------

                        json.append("\"session\":{");

                        json.append("\"sessionId\":")
                                        .append(sessionId)
                                        .append(",");

                        json.append("\"startedAt\":\"")
                                        .append(
                                                        escapeJson(
                                                                        startedAt))
                                        .append("\",");

                        json.append("\"currentTurn\":")
                                        .append(currentTurn)
                                        .append(",");

                        json.append("\"gameStatus\":\"")
                                        .append(
                                                        escapeJson(
                                                                        gameStatus))
                                        .append("\",");

                        json.append("\"playerCount\":")
                                        .append(playerCount);

                        json.append("},");

                        // -------------------------------------------------
                        // PLAYERS
                        // -------------------------------------------------

                        json.append("\"players\":[");

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            MemberID,
                                                                            MemberName,
                                                                            PlayerStatus,
                                                                            TotalScore
                                                                        FROM vw_game_roster
                                                                        WHERE SessionID = ?
                                                                        ORDER BY MemberID
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        boolean first = true;

                                        while (result.next()) {

                                                if (!first) {
                                                        json.append(",");
                                                }

                                                first = false;

                                                json.append("{");

                                                json.append("\"memberId\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "MemberID"))
                                                                .append(",");

                                                json.append("\"name\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "MemberName")))
                                                                .append("\",");

                                                json.append("\"status\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "PlayerStatus")))
                                                                .append("\",");

                                                json.append("\"score\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "TotalScore"));

                                                json.append("}");
                                        }
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // CURRENT ACTIVITIES
                        // -------------------------------------------------

                        json.append("\"activities\":[");

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            MemberName,
                                                                            SiteName,
                                                                            ActivityName,
                                                                            ActivityCategory
                                                                        FROM vw_activity_log
                                                                        WHERE SessionID = ?
                                                                          AND TurnNumber = ?
                                                                        ORDER BY MemberID
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                statement.setInt(
                                                2,
                                                currentTurn);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        boolean first = true;

                                        while (result.next()) {

                                                if (!first) {
                                                        json.append(",");
                                                }

                                                first = false;

                                                json.append("{");

                                                json.append("\"player\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "MemberName")))
                                                                .append("\",");

                                                json.append("\"site\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "SiteName")))
                                                                .append("\",");

                                                json.append("\"activity\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "ActivityName")))
                                                                .append("\",");

                                                json.append("\"category\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "ActivityCategory")))
                                                                .append("\"");

                                                json.append("}");
                                        }
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // CONTACT HISTORY
                        // -------------------------------------------------

                        json.append("\"contacts\":[");

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            TurnNumber,
                                                                            PlayerAName,
                                                                            PlayerBName,
                                                                            SiteName
                                                                        FROM vw_contact_log
                                                                        WHERE SessionID = ?
                                                                          AND TurnNumber <= ?
                                                                        ORDER BY
                                                                            TurnNumber,
                                                                            ContactEventID
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                statement.setInt(
                                                2,
                                                currentTurn);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        boolean first = true;

                                        while (result.next()) {

                                                if (!first) {
                                                        json.append(",");
                                                }

                                                first = false;

                                                json.append("{");

                                                json.append("\"turn\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "TurnNumber"))
                                                                .append(",");

                                                json.append("\"playerA\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "PlayerAName")))
                                                                .append("\",");

                                                json.append("\"playerB\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "PlayerBName")))
                                                                .append("\",");

                                                json.append("\"site\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "SiteName")))
                                                                .append("\"");

                                                json.append("}");
                                        }
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // DISCOVERED CLUES
                        // -------------------------------------------------

                        json.append("\"clues\":[");

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            ObserverName,
                                                                            AffectedMemberName,
                                                                            SymptomCode,
                                                                            AppearanceTurn,
                                                                            DiscoveredTurn,
                                                                            DetectionDelay,
                                                                            PotentialPoints,
                                                                            Severity
                                                                        FROM vw_observation_log
                                                                        WHERE SessionID = ?
                                                                        ORDER BY ObservationID
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        boolean first = true;

                                        while (result.next()) {

                                                if (!first) {
                                                        json.append(",");
                                                }

                                                first = false;

                                                json.append("{");

                                                json.append("\"observer\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "ObserverName")))
                                                                .append("\",");

                                                json.append("\"affectedPlayer\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "AffectedMemberName")))
                                                                .append("\",");

                                                json.append("\"symptom\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "SymptomCode")))
                                                                .append("\",");

                                                json.append("\"appearanceTurn\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "AppearanceTurn"))
                                                                .append(",");

                                                json.append("\"discoveredTurn\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "DiscoveredTurn"))
                                                                .append(",");

                                                json.append("\"detectionDelay\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "DetectionDelay"))
                                                                .append(",");

                                                json.append("\"points\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "PotentialPoints"))
                                                                .append(",");

                                                json.append("\"severity\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "Severity"));

                                                json.append("}");
                                        }
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // ACCUSATIONS
                        // -------------------------------------------------

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            COUNT(ae.AccusationID)
                                                                                AS TotalAccusations,

                                                                            COALESCE(
                                                                                SUM(
                                                                                    CASE
                                                                                        WHEN ae.AccusedMemberID
                                                                                            <> ist.MemberID
                                                                                        THEN 1
                                                                                        ELSE 0
                                                                                    END
                                                                                ),
                                                                                0
                                                                            ) AS WrongAccusations

                                                                        FROM ACCUSATION_EVENT AS ae

                                                                        JOIN INFECTION_STATE AS ist
                                                                            ON ae.SessionID = ist.SessionID
                                                                           AND ist.PatientZero = TRUE

                                                                        WHERE ae.SessionID = ?
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        result.next();

                                        json.append("\"accusations\":{");

                                        json.append("\"total\":")
                                                        .append(
                                                                        result.getInt(
                                                                                        "TotalAccusations"))
                                                        .append(",");

                                        json.append("\"wrong\":")
                                                        .append(
                                                                        result.getInt(
                                                                                        "WrongAccusations"));

                                        json.append("}");
                                }
                        }

                        json.append("}");

                        sendJson(
                                        exchange,
                                        200,
                                        json.toString());

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        500,
                                        e.getMessage());
                }
        }

        // =========================================================
        // OPTIONS FOR FRONTEND DROPDOWNS
        // =========================================================

        private static void handleOptions(
                        HttpExchange exchange) throws IOException {

                int sessionId;

                try {

                        sessionId = getSessionId(
                                        exchange);

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid session ID.");

                        return;
                }

                try (
                                Connection connection = getConnection()) {

                        StringBuilder json = new StringBuilder();

                        json.append("{");

                        // -------------------------------------------------
                        // PLAYERS
                        // -------------------------------------------------

                        json.append("\"players\":[");

                        try (
                                        PreparedStatement statement = connection.prepareStatement(
                                                        """
                                                                        SELECT
                                                                            MemberID,
                                                                            MemberName,
                                                                            PlayerStatus
                                                                        FROM vw_game_roster
                                                                        WHERE SessionID = ?
                                                                        ORDER BY MemberID
                                                                        """)) {

                                statement.setInt(
                                                1,
                                                sessionId);

                                try (
                                                ResultSet result = statement.executeQuery()) {

                                        boolean first = true;

                                        while (result.next()) {

                                                if (!first) {
                                                        json.append(",");
                                                }

                                                first = false;

                                                json.append("{");

                                                json.append("\"memberId\":")
                                                                .append(
                                                                                result.getInt(
                                                                                                "MemberID"))
                                                                .append(",");

                                                json.append("\"name\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "MemberName")))
                                                                .append("\",");

                                                json.append("\"status\":\"")
                                                                .append(
                                                                                escapeJson(
                                                                                                result.getString(
                                                                                                                "PlayerStatus")))
                                                                .append("\"");

                                                json.append("}");
                                        }
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // SITES
                        // -------------------------------------------------

                        json.append("\"sites\":[");

                        try (
                                        Statement statement = connection.createStatement();

                                        ResultSet result = statement.executeQuery(
                                                        """
                                                                        SELECT
                                                                            SiteID,
                                                                            SiteName
                                                                        FROM VACATION_SITE
                                                                        ORDER BY SiteID
                                                                        """)) {

                                boolean first = true;

                                while (result.next()) {

                                        if (!first) {
                                                json.append(",");
                                        }

                                        first = false;

                                        json.append("{");

                                        json.append("\"siteId\":")
                                                        .append(
                                                                        result.getInt(
                                                                                        "SiteID"))
                                                        .append(",");

                                        json.append("\"name\":\"")
                                                        .append(
                                                                        escapeJson(
                                                                                        result.getString(
                                                                                                        "SiteName")))
                                                        .append("\"");

                                        json.append("}");
                                }
                        }

                        json.append("],");

                        // -------------------------------------------------
                        // SITE / ACTIVITY COMBINATIONS
                        // -------------------------------------------------

                        json.append("\"siteActivities\":[");

                        try (
                                        Statement statement = connection.createStatement();

                                        ResultSet result = statement.executeQuery(
                                                        """
                                                                        SELECT
                                                                            sa.SiteID,
                                                                            vs.SiteName,
                                                                            sa.ActivityID,
                                                                            a.ActivityName
                                                                        FROM SITE_ACTIVITY AS sa

                                                                        JOIN VACATION_SITE AS vs
                                                                            ON sa.SiteID = vs.SiteID

                                                                        JOIN ACTIVITY AS a
                                                                            ON sa.ActivityID = a.ActivityID

                                                                        ORDER BY
                                                                            sa.SiteID,
                                                                            sa.ActivityID
                                                                        """)) {

                                boolean first = true;

                                while (result.next()) {

                                        if (!first) {
                                                json.append(",");
                                        }

                                        first = false;

                                        json.append("{");

                                        json.append("\"siteId\":")
                                                        .append(
                                                                        result.getInt(
                                                                                        "SiteID"))
                                                        .append(",");

                                        json.append("\"siteName\":\"")
                                                        .append(
                                                                        escapeJson(
                                                                                        result.getString(
                                                                                                        "SiteName")))
                                                        .append("\",");

                                        json.append("\"activityId\":")
                                                        .append(
                                                                        result.getInt(
                                                                                        "ActivityID"))
                                                        .append(",");

                                        json.append("\"activityName\":\"")
                                                        .append(
                                                                        escapeJson(
                                                                                        result.getString(
                                                                                                        "ActivityName")))
                                                        .append("\"");

                                        json.append("}");
                                }
                        }

                        json.append("]");

                        json.append("}");

                        sendJson(
                                        exchange,
                                        200,
                                        json.toString());

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        500,
                                        e.getMessage());
                }
        }

        // =========================================================
        // RECORD ACTIVITY
        // =========================================================

        private static void handleActivity(
                        HttpExchange exchange) throws IOException {

                if (!requirePost(exchange)) {
                        return;
                }

                try {

                        String body = readBody(
                                        exchange);

                        int session = getFormInt(
                                        body,
                                        "session");

                        int member = getFormInt(
                                        body,
                                        "member");

                        int site = getFormInt(
                                        body,
                                        "site");

                        int activity = getFormInt(
                                        body,
                                        "activity");

                        callProcedure(
                                        "{CALL RecordActivity(?,?,?,?)}",
                                        session,
                                        member,
                                        site,
                                        activity);

                        sendSuccess(
                                        exchange,
                                        "Activity recorded.");

                } catch (SQLException e) {

                        sendError(
                                        exchange,
                                        400,
                                        sqlMessage(e));

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid activity request.");
                }
        }

        // =========================================================
        // RECORD CONTACT
        // =========================================================

        private static void handleContact(
                        HttpExchange exchange) throws IOException {

                if (!requirePost(exchange)) {
                        return;
                }

                try {

                        String body = readBody(
                                        exchange);

                        int session = getFormInt(
                                        body,
                                        "session");

                        int playerA = getFormInt(
                                        body,
                                        "playerA");

                        int playerB = getFormInt(
                                        body,
                                        "playerB");

                        int site = getFormInt(
                                        body,
                                        "site");

                        callProcedure(
                                        "{CALL RecordContact(?,?,?,?)}",
                                        session,
                                        playerA,
                                        playerB,
                                        site);

                        sendSuccess(
                                        exchange,
                                        "Contact recorded.");

                } catch (SQLException e) {

                        sendError(
                                        exchange,
                                        400,
                                        sqlMessage(e));

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid contact request.");
                }
        }

        // =========================================================
        // INVESTIGATE
        // =========================================================

        private static void handleInvestigate(
                        HttpExchange exchange) throws IOException {

                if (!requirePost(exchange)) {
                        return;
                }

                try {

                        String body = readBody(
                                        exchange);

                        int session = getFormInt(
                                        body,
                                        "session");

                        int observer = getFormInt(
                                        body,
                                        "observer");

                        callProcedure(
                                        "{CALL InvestigateForClue(?,?)}",
                                        session,
                                        observer);

                        sendSuccess(
                                        exchange,
                                        "Investigation completed. Any discovered evidence is now shown on the dashboard.");

                } catch (SQLException e) {

                        sendError(
                                        exchange,
                                        400,
                                        sqlMessage(e));

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid investigation request.");
                }
        }

        // =========================================================
        // ACCUSE
        // =========================================================

        private static void handleAccuse(
                        HttpExchange exchange) throws IOException {

                if (!requirePost(exchange)) {
                        return;
                }

                try {

                        String body = readBody(
                                        exchange);

                        int session = getFormInt(
                                        body,
                                        "session");

                        int accuser = getFormInt(
                                        body,
                                        "accuser");

                        int accused = getFormInt(
                                        body,
                                        "accused");

                        callProcedure(
                                        "{CALL MakeAccusation(?,?,?)}",
                                        session,
                                        accuser,
                                        accused);

                        sendSuccess(
                                        exchange,
                                        "Accusation submitted.");

                } catch (SQLException e) {

                        sendError(
                                        exchange,
                                        400,
                                        sqlMessage(e));

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid accusation request.");
                }
        }

        // =========================================================
        // ADVANCE TURN
        // =========================================================

        private static void handleAdvance(
                        HttpExchange exchange) throws IOException {

                if (!requirePost(exchange)) {
                        return;
                }

                try {

                        String body = readBody(
                                        exchange);

                        int session = getFormInt(
                                        body,
                                        "session");

                        callProcedure(
                                        "{CALL AdvanceTurn(?)}",
                                        session);

                        sendSuccess(
                                        exchange,
                                        "Turn advanced.");

                } catch (SQLException e) {

                        sendError(
                                        exchange,
                                        400,
                                        sqlMessage(e));

                } catch (Exception e) {

                        sendError(
                                        exchange,
                                        400,
                                        "Invalid advance-turn request.");
                }
        }

        // =========================================================
        // DATABASE HELPERS
        // =========================================================

        private static Connection getConnection()
                        throws SQLException {

                return DriverManager.getConnection(
                                DB_URL,
                                DB_USER,
                                dbPassword);
        }

        private static void callProcedure(
                        String sql,
                        int... values) throws SQLException {

                try (
                                Connection connection = getConnection();

                                CallableStatement statement = connection.prepareCall(
                                                sql)) {

                        for (int i = 0; i < values.length; i++) {

                                statement.setInt(
                                                i + 1,
                                                values[i]);
                        }

                        boolean hasResults = statement.execute();

                        while (true) {

                                if (hasResults) {

                                        try (
                                                        ResultSet result = statement.getResultSet()) {

                                                while (result != null
                                                                && result.next()) {
                                                        // Stored procedure output is
                                                        // intentionally consumed here.
                                                }
                                        }

                                } else {

                                        if (statement.getUpdateCount() == -1) {
                                                break;
                                        }
                                }

                                hasResults = statement.getMoreResults();
                        }
                }
        }

        // =========================================================
        // REQUEST HELPERS
        // =========================================================

        private static boolean requirePost(
                        HttpExchange exchange) throws IOException {

                if (!exchange
                                .getRequestMethod()
                                .equalsIgnoreCase(
                                                "POST")) {

                        sendError(
                                        exchange,
                                        405,
                                        "POST required.");

                        return false;
                }

                return true;
        }

        private static String readBody(
                        HttpExchange exchange) throws IOException {

                return new String(
                                exchange
                                                .getRequestBody()
                                                .readAllBytes(),
                                StandardCharsets.UTF_8);
        }

        private static int getFormInt(
                        String body,
                        String key) {

                for (String pair : body.split("&")) {

                        String[] parts = pair.split(
                                        "=",
                                        2);

                        if (parts.length == 2
                                        && parts[0].equals(key)) {

                                String value = URLDecoder.decode(
                                                parts[1],
                                                StandardCharsets.UTF_8);

                                return Integer.parseInt(
                                                value);
                        }
                }

                throw new IllegalArgumentException(
                                "Missing field: " + key);
        }

        private static int getSessionId(
                        HttpExchange exchange) {

                String query = exchange
                                .getRequestURI()
                                .getRawQuery();

                if (query == null
                                || query.isBlank()) {
                        return 1;
                }

                for (String pair : query.split("&")) {

                        String[] parts = pair.split(
                                        "=",
                                        2);

                        if (parts.length == 2
                                        && parts[0].equals(
                                                        "session")) {

                                String value = URLDecoder.decode(
                                                parts[1],
                                                StandardCharsets.UTF_8);

                                int sessionId = Integer.parseInt(
                                                value);

                                if (sessionId < 1) {

                                        throw new IllegalArgumentException();
                                }

                                return sessionId;
                        }
                }

                return 1;
        }

        // =========================================================
        // RESPONSE HELPERS
        // =========================================================

        private static void sendSuccess(
                        HttpExchange exchange,
                        String message) throws IOException {

                String json = """
                                {
                                  "status":"ok",
                                  "message":"%s"
                                }
                                """.formatted(
                                escapeJson(
                                                message));

                sendJson(
                                exchange,
                                200,
                                json);
        }

        private static void sendJson(
                        HttpExchange exchange,
                        int status,
                        String json) throws IOException {

                send(
                                exchange,
                                status,
                                "application/json; charset=UTF-8",
                                json);
        }

        private static void sendError(
                        HttpExchange exchange,
                        int status,
                        String message) throws IOException {

                String json = """
                                {
                                  "status":"error",
                                  "message":"%s"
                                }
                                """.formatted(
                                escapeJson(
                                                message));

                sendJson(
                                exchange,
                                status,
                                json);
        }

        private static void send(
                        HttpExchange exchange,
                        int status,
                        String contentType,
                        String body) throws IOException {

                byte[] bytes = body.getBytes(
                                StandardCharsets.UTF_8);

                exchange
                                .getResponseHeaders()
                                .set(
                                                "Content-Type",
                                                contentType);

                exchange.sendResponseHeaders(
                                status,
                                bytes.length);

                try (
                                OutputStream output = exchange.getResponseBody()) {

                        output.write(
                                        bytes);
                }
        }

        private static String sqlMessage(
                        SQLException e) {

                String message = e.getMessage();

                if (message == null
                                || message.isBlank()) {
                        return "Database operation failed.";
                }

                return message;
        }

        private static String escapeJson(
                        String value) {

                if (value == null) {
                        return "";
                }

                return value
                                .replace(
                                                "\\",
                                                "\\\\")
                                .replace(
                                                "\"",
                                                "\\\"")
                                .replace(
                                                "\n",
                                                "\\n")
                                .replace(
                                                "\r",
                                                "\\r")
                                .replace(
                                                "\t",
                                                "\\t");
        }
}