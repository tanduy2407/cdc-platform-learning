# Ghi chú chi tiết từng bài — Series "Modern Data Platform" (Duong Pham, Substack, 01–17/10/2026)

Nguồn: https://duongpk9x.substack.com/s/data-platform/archive?sort=new
Mỗi bài gồm 12 mục: Bối cảnh · Luận điểm · Khái niệm · Kiến trúc · Framework quyết định · Best practices · Anti-patterns · Ví dụ · Công nghệ · Checklist · Takeaways · Liên kết.

---

# Tóm tắt Bài 1–3 — Series "Modern Data Platform" (Duong Pham, Substack, 10/2026)

## Bài 1: Một Data Platform hiện đại nên được thiết kế như thế nào?
*Tiêu đề gốc: "Modern Data Platform - Bài 1: Một Data Platform hiện đại nên được thiết kế như thế nào?" · Subtitle: Data Platform Từ Lý thuyết đến Thực chiến · Đăng 2026-10-01 · 2 bảng dạng ảnh*

Mục lục (H2): 1. Data Platform thực sự là gì? | 2. Tổng quan kiến trúc Modern Data Platform | 3. Source Layer – Dữ liệu đến từ đâu? | 4. Ingestion Layer – Làm thế nào đưa dữ liệu vào platform? | 5. Storage Layer - Data Lake, Lakehouse và Data Warehouse | 6. Processing và Serving - Biến đổi và cung cấp dữ liệu | 7. Governance, Data Quality và Security | 8. Operations, Observability và Cost Management | 9. Modern Data Platform khác Data Warehouse truyền thống ở đâu? | 10. Một ví dụ Modern Data Platform tiêu biểu | 11. Kết luận | Series tiếp theo

**1. Bối cảnh & vấn đề mở đầu**
- Khi bắt đầu dự án Data Platform, người ta thường hỏi ngay "Nên dùng công nghệ gì?": Microsoft Fabric, Databricks, Snowflake, Kafka, Spark, Airflow hay Power BI. Theo tác giả, đây **chưa phải** câu hỏi đầu tiên.
- Một Data Platform tốt bắt đầu từ hai câu hỏi: (1) hệ thống cần giải quyết vấn đề gì; (2) khi có sự cố, hệ thống sẽ được vận hành và khôi phục ra sao. Đây là điểm xuất phát của cả series.

**2. Luận điểm cốt lõi**
Modern Data Platform không phải là "Database + ETL + BI". Đó là một hệ thống nhiều lớp phối hợp với nhau, theo thứ tự Source → Ingestion → Storage → Processing → Serving → Consumers. Bao trùm các lớp này là sáu yếu tố: Security, Governance, Data Quality, Observability, Operations và Cost Management. Kiến trúc phải xuất phát từ business requirements, workload và khả năng vận hành, khôi phục. Fabric và Databricks chỉ là phương tiện để hiện thực hóa, nên được chọn sau.

**3. Khái niệm chính**
- **Data Platform**: "hệ thống giúp tổ chức thu thập, lưu trữ, xử lý, quản lý và cung cấp dữ liệu cho nhiều nhu cầu nghiệp vụ khác nhau". Nó không phải một database đơn lẻ.
- **6 lớp trong conceptual architecture**:
  - Sources: nơi phát sinh dữ liệu.
  - Ingestion: thu thập dữ liệu vào platform.
  - Storage: lưu trữ theo nhu cầu sử dụng.
  - Processing: làm sạch, biến đổi và áp dụng business rules.
  - Serving: cung cấp dữ liệu theo hình thức phù hợp với người dùng và ứng dụng.
  - Consumers: các hệ thống và nhóm người dùng khai thác dữ liệu.
- **6 yếu tố xuyên suốt**:
  - Governance: quản lý dữ liệu, quyền sở hữu và trách nhiệm.
  - Data Quality: dữ liệu đáp ứng các tiêu chí chất lượng.
  - Security: bảo vệ dữ liệu và kiểm soát truy cập.
  - Observability: theo dõi trạng thái và phát hiện bất thường.
  - Operations: vận hành, xử lý sự cố và khôi phục.
  - Cost Management: chi phí và hiệu quả sử dụng tài nguyên.
- **Hai khía cạnh của ingestion**:
  - Full Load, Incremental và CDC mô tả *cách lấy dữ liệu hoặc xác định thay đổi*.
  - Batch và Streaming mô tả *cách tổ chức việc tiếp nhận và xử lý theo thời gian*.
  - Hai khía cạnh này kết hợp được với nhau. "CDC không đồng nghĩa với Real-time."
- **Data Lake, Data Warehouse, Data Lakehouse**: Lakehouse = Data Lake + "warehouse-like capabilities".
- **Các thành phần Serving**: Data Mart, Semantic Model, SQL Endpoint, API, Feature Store.
- **Các tiêu chí Data Quality**:
  - Completeness: dữ liệu có đầy đủ không.
  - Accuracy: dữ liệu có chính xác không.
  - Uniqueness: có bản ghi trùng không.
  - Consistency: dữ liệu có nhất quán không.
  - Freshness: dữ liệu có được cập nhật đúng hạn không.
  - Validity: dữ liệu có tuân thủ quy tắc hợp lệ không.
- **Thành phần Governance**: Authentication, Authorization, RBAC, Row-level Security, Column-level Security, Data Classification, Data Lineage, Audit.
- **Các lớp Security**: Identity & Authentication, Authorization, Encryption, Network Security, Secrets Management, Audit, Data Classification.
- **Architectural trade-off**: các lựa chọn không có đáp án luôn đúng trong mọi tình huống.

**4. Kiến trúc, pattern & quy trình**
- **Stack 6 lớp**: `Sources (DB/API/Files/Events/External) → Ingestion (Batch/Incremental/CDC/Streaming) → Storage (Data Lake/Lakehouse/Warehouse) → Data Processing (Transform/Join/Aggregate/Enrichment) → Serving (Semantic Model/Data Mart/API/SQL) → Consumers (BI/Reporting/Risk/AI-ML/Apps)`.
- **Mỗi nguồn một cách ingest**:
  - `Oracle Transaction DB —CDC→ Data Platform`
  - `CSV File —Batch→ Data Platform`
  - `Market Data —Streaming→ Data Platform`
- **Các tổ hợp hợp lệ**: Batch + Full Load, Batch + Incremental, Batch + CDC, Streaming + Event, Streaming + CDC.
- **Processing**:
  - Luồng ví dụ: `Oracle → Raw Customer → Clean Customer → Customer 360`.
  - Các bước có thể gồm: Filter/Transform, Join nhiều nguồn, Deduplicate, Aggregate, Enrichment, DQ checks, Business Rules.
  - Có thể triển khai bằng SQL, Python, Spark hoặc engine khác.
- **Serving**:
  - Luồng: `Gold → {BI Model → Power BI | Risk API | AI/ML}`.
  - Thiết kế theo từng nhóm người dùng:
    - BI/Reporting: dữ liệu đã chuẩn hóa và mô hình hóa cho báo cáo.
    - Analytics: dữ liệu phù hợp để truy vấn và phân tích.
    - Risk: chỉ số, danh mục và dữ liệu nghiệp vụ cho phân tích rủi ro.
    - AI/ML: dữ liệu cho huấn luyện, suy luận và ứng dụng AI.
    - Applications: dữ liệu cung cấp qua API hoặc giao diện truy vấn.
- **Đối soát DQ giữa các lớp**:
  - Luồng: `Source Count → Ingestion Count → Silver Count → Gold Count → Abnormal Difference? → Alert / Investigation`.
  - Ngoài số lượng bản ghi còn kiểm tra khóa duy nhất, null, phạm vi giá trị, tính toàn vẹn và business rules.
  - DQ phải nối với cơ chế cảnh báo và vận hành.
- **Mô hình Security**: `User → Identity Provider → Workspace/Platform → {RBAC, Dataset Permission, Row-level Security, Column-level Security}`.
- **Operations & Recovery theo 4 kịch bản**:
  - Pipeline thất bại: retry, alert, resume, checkpoint, manual rerun. Phải xử lý trường hợp pipeline đã chạy một phần để tránh mất dữ liệu hoặc ghi trùng.
  - Source DB không khả dụng: retry, backoff, alert, recovery.
  - Dữ liệu trùng hoặc không hợp lệ: xác định điểm kiểm tra DQ; đưa vào quarantine hoặc reject thay vì để đi tiếp vào các lớp phục vụ business.
  - Platform outage: backup, Disaster Recovery, quy trình khôi phục dữ liệu và pipeline.
- **Observability** (không chỉ dựa vào SUCCESS/FAILED): trạng thái pipeline và từng bước; thời gian chạy và độ trễ dữ liệu; khối lượng đầu vào/đầu ra; tỷ lệ lỗi và số lần retry; bất thường về DQ; mức sử dụng compute và storage.
- **Chi phí**: `Total Cost = Storage + Compute + Network + Licensing + Operational`. Trên cloud, compute và storage có thể được tính phí riêng thay vì gắn cố định vào một database server.
- **Truyền thống so với hiện đại**:
  - Truyền thống: `Source → ETL → Data Warehouse → BI`.
  - Hiện đại: `Multiple Data Sources → Batch/CDC/Streaming → Lake/Lakehouse → Processing Layer → Serving/Semantic → {BI, Analytics, Risk, AI/ML}`.
- **Reference architecture cho công ty chứng khoán**: `Oracle/Tibero/Market Data API → Ingestion Layer (Batch/Incremental/CDC) → Bronze/Raw → Silver/Business → Gold/Serving → {Semantic → Power BI ; Risk API}`.

**5. Framework ra quyết định & so sánh**

Bảng ảnh 1 – Nhóm nguồn dữ liệu:

| Nhóm nguồn | Ví dụ |
|---|---|
| Database | Oracle, Tibero, PostgreSQL, SQL Server, MySQL, MariaDB |
| Application/API | REST API, GraphQL, Market Data API |
| File | CSV, JSON, XML, Excel, Parquet |
| Event/Streaming | Kafka, Event Hub, Message Queue |
| External Data | Dữ liệu từ hệ thống hoặc nhà cung cấp bên ngoài |

- **Tiêu chí mô tả source** (cơ sở để chọn ingestion):
  - Loại nguồn: database, API, file hay event.
  - Mức độ cấu trúc: structured, semi-structured hay dạng khác.
  - Dữ liệu phát sinh theo lịch hay liên tục.
  - Khối lượng ban đầu và tốc độ thay đổi.
  - Khả năng incremental hoặc CDC.
  - Giới hạn truy cập và yêu cầu bảo vệ hệ thống nguồn.
- **Chọn Storage**:
  - Data Lake hợp với raw data, dữ liệu quy mô lớn, bán cấu trúc, dạng file và dữ liệu lịch sử.
  - Data Warehouse hợp với dữ liệu có cấu trúc, analytical queries, Reporting/BI, dimensional model và workload phân tích đã tổ chức rõ ràng.
  - Lakehouse phổ biến vì đáp ứng nhiều nhu cầu trên cùng một kiến trúc, nhưng **không bắt buộc**. Lựa chọn tùy workload, quy mô, yêu cầu quản trị, năng lực vận hành và chi phí.
- **Chọn engine**: thay vì hỏi "Spark hay SQL?", hãy hỏi "*Workload này cần xử lý như thế nào, khối lượng bao nhiêu, SLA ra sao, chi phí chấp nhận được bao nhiêu?*"
- **Các trade-off về chi phí**:
  - Compute khi cần hay luôn chạy.
  - Hot data hay cold data.
  - Real-time hay Batch.
  - Hiệu năng cao hay chi phí thấp.
  - Khả năng mở rộng hay độ phức tạp vận hành.
  - Mức độ sẵn sàng cao hay chi phí hạ tầng bổ sung.
  - Ví dụ: báo cáo chỉ chạy vài lần mỗi ngày không cần compute luôn chạy ở mức cao; workload cần độ trễ thấp và đáp ứng liên tục thì cần thiết kế khác.
- **DW truyền thống so với MDP**: khác biệt không chỉ ở technology mà ở **phạm vi workload** (BI, Analytics, Data Science, AI/ML, Risk, Operational Analytics, nhu cầu gần real-time). Data Warehouse **không lỗi thời** và vẫn quan trọng cho workload báo cáo có cấu trúc rõ.

Bảng ảnh 2 – Vị trí của Fabric và Databricks (tác giả nhấn mạnh đây *không phải* ánh xạ một-một):

| Microsoft Fabric | Databricks |
|---|---|
| OneLake | Delta Lake và các thành phần lưu trữ lakehouse |
| Data Factory | Các khả năng tích hợp và xử lý dữ liệu |
| Data Engineering | Spark và các công cụ xử lý dữ liệu |
| Warehouse | SQL và các khả năng phân tích |
| Power BI | Các khả năng phục vụ Data Science, ML và AI |

- Không nên hiểu "Modern Data Platform = Microsoft Fabric" hay "= Databricks". Câu hỏi kiến trúc đúng là: **"Workload nào nên chạy ở đâu, và vì sao?"**
- Không chọn Fabric chỉ vì khách hàng đang dùng hệ sinh thái Microsoft. Không chọn Databricks chỉ vì dữ liệu lớn. Hãy chọn theo workload thực tế, yêu cầu nghiệp vụ, SLA, năng lực vận hành và tổng chi phí.

**6. Best practices / nguyên tắc thiết kế**
- Bắt đầu từ vấn đề business và kịch bản sự cố, khôi phục; công nghệ tính sau.
- Hiểu đặc điểm từng nguồn rồi mới chọn ingestion. Không mặc định dùng một phương thức cho mọi nguồn.
- Thiết kế Ingestion đặc biệt cẩn thận vì lỗi ở đây ảnh hưởng mọi lớp phía sau. Mục tiêu: dữ liệu "đúng, đủ và đúng thời điểm" theo yêu cầu nghiệp vụ.
- Xác định vai trò của Storage Layer trước khi chọn công nghệ lưu trữ. Hiểu workload trước khi chọn engine.
- Thiết kế Serving theo nhu cầu từng nhóm người dùng.
- Governance, DQ và Security phải được thiết kế xuyên suốt từ đầu, không phải tính năng thêm sau khi vận hành. Dữ liệu tài chính (Customer, Account, Order, Portfolio, Margin, Transaction) cần được bảo vệ ngay từ giai đoạn thiết kế.
- DQ phải gắn với alert và vận hành. Dữ liệu lỗi đi vào quarantine hoặc reject.
- Kiến trúc phải trả lời được câu hỏi "nếu một thành phần gặp sự cố thì hệ thống phản ứng thế nào".
- Đánh giá cùng lúc chi phí, hiệu năng, SLA, khả năng phục hồi và yêu cầu nghiệp vụ.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Bắt đầu dự án bằng việc chọn công cụ.
- Coi Data Platform = Database + ETL + BI.
- Một phương thức ingestion cho mọi nguồn; đồng nhất CDC với Real-time.
- Mặc định mọi dự án phải dùng Lakehouse.
- Tranh luận "Spark hay SQL" trước khi hiểu workload.
- Platform xử lý hàng terabyte tốt nhưng người dùng cuối vẫn phải viết SQL phức tạp để lấy một báo cáo đơn giản, tức là chưa giải quyết được bài toán business.
- Tin rằng pipeline SUCCESS nghĩa là dữ liệu đúng; vận hành chỉ dựa vào SUCCESS/FAILED.
- Rerun một pipeline đã chạy một phần mà không có kiểm soát, dẫn đến mất hoặc trùng dữ liệu.
- "Một architecture diagram đẹp chưa chắc là một architecture tốt." Kiến trúc đúng về kỹ thuật nhưng chi phí quá cao vẫn có thể không phù hợp.
- Đánh đồng MDP với một sản phẩm cụ thể; nghĩ rằng DW đã lỗi thời.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **Nguồn**:
  - Oracle/Tibero: Customer, Account, Order, Trade, Portfolio.
  - Market Data API: Price, Volume, Market Index.
  - Hệ thống khác: Risk, CRM, External Data.
- **Nhu cầu sử dụng**: BI/Reporting, Business Analytics, Risk Management, Data Science & AI/ML, Operational Analytics, ứng dụng nghiệp vụ.
- **Ingestion**: giao dịch Oracle qua CDC; CSV nạp batch theo lịch; Market Data qua API hoặc streaming.
- **Trade Fact**: `ORDER + EXECUTION + CUSTOMER + ACCOUNT + SECURITY → Trade Fact → Trading Analytics`.
- **Phân quyền**: Trader → Trading Data; Risk → Portfolio, Margin, Risk Metrics; Management → Aggregated BI.
- **Ví dụ DQ**: Customer count hôm qua là 1,000,000, hôm nay chỉ 100,000, nhưng pipeline vẫn báo SUCCESS.
- **Mục 10**: chỉ sau khi có kiến trúc logic Bronze/Silver/Gold mới bàn đến quyết định triển khai (xem mục 10 bên dưới).

**9. Công nghệ/công cụ được nhắc tới**
- **Microsoft Fabric** (OneLake, Data Factory, Data Engineering, Warehouse, Fabric Spark, SQL endpoint, Semantic Model, Power BI) và **Databricks** (Delta Lake, Spark, SQL, khả năng DS/ML/AI): các nền tảng để *hiện thực hóa* thành phần của MDP, không phải bản thân MDP.
- Snowflake, Kafka, Spark, Airflow, Power BI: được nêu trong câu hỏi mở đầu "chọn công nghệ gì" để minh họa cách tiếp cận sai thứ tự.
- **Nguồn dữ liệu**: Oracle, Tibero, PostgreSQL, SQL Server, MySQL, MariaDB; REST API, GraphQL, Market Data API; CSV, JSON, XML, Excel, Parquet; Kafka, Event Hub, Message Queue.
- **Processing engines**: SQL, Python, Spark.
- **Khác**: Power BI ở tầng tiêu thụ; Identity Provider cho xác thực.

**10. Checklist / câu hỏi thiết kế**
- **Câu hỏi ingestion (mục 4)**:
  - Có cần nạp toàn bộ dữ liệu ban đầu không?
  - Xác định dữ liệu mới hoặc thay đổi bằng cách nào?
  - Source có hỗ trợ CDC không?
  - Độ trễ cho phép là bao nhiêu?
  - Dữ liệu có thể trùng hoặc đến sai thứ tự không?
  - Pipeline lỗi có chạy lại an toàn được không?
  - Làm sao không bỏ sót dữ liệu khi hệ thống phục hồi?
- **Quyết định triển khai (mục 10)**:
  - Storage: Bronze đặt ở OneLake, Delta Lake hay giải pháp khác? Có cần DW riêng không? Quản lý dữ liệu lịch sử và dữ liệu truy cập thường xuyên ra sao?
  - Processing: Fabric Spark, Databricks hay SQL engine? Workload nào batch, workload nào near real-time hoặc streaming?
  - Serving: Fabric Warehouse, SQL endpoint, Semantic Model hay API? Mô hình hóa thế nào cho BI, Risk và AI/ML?
  - Governance & Security: ai được truy cập dữ liệu khách hàng và giao dịch? Phân quyền ở cấp dataset, row, column thế nào? Lineage và Audit ra sao?
  - Operations & Cost: khôi phục pipeline thế nào? Có kiểm tra DQ trước khi phục vụ business không? Đánh giá SLA, khả năng mở rộng và chi phí ra sao?
- **8 câu hỏi kiến trúc (kết luận)**:
  1. Business cần giải quyết vấn đề gì?
  2. Dữ liệu đến từ đâu và có đặc điểm gì?
  3. Workload cần Batch, CDC hay Streaming?
  4. Dữ liệu được lưu trữ và biến đổi như thế nào?
  5. Người dùng và ứng dụng khai thác dữ liệu ra sao?
  6. Bảo đảm DQ, Security, Governance bằng cách nào?
  7. Hệ thống được giám sát, vận hành và khôi phục thế nào?
  8. Chi phí và khả năng mở rộng có phù hợp không?
- **Roadmap series**: `Ingestion → Lake/Lakehouse/Warehouse → Microsoft Fabric & OneLake → Medallion Architecture → Fabric Data Engineering → Batch/CDC/Streaming → Semantic Layer & Power BI → Governance/Security/Operations → Fabric vs Databricks → Securities Data Platform Case Study`.

**11. Kết luận & key takeaways**
- MDP là nhiều lớp phối hợp cộng với sáu yếu tố xuyên suốt, không phải "Database + ETL + BI".
- Mỗi nguồn có đặc điểm riêng nên cần phương thức ingestion phù hợp; CDC ≠ Real-time.
- Lựa chọn storage và engine đều dựa trên workload, SLA và chi phí.
- Serving quyết định business thực sự nhìn thấy và dùng dữ liệu như thế nào.
- Governance, DQ, Security, Operations và Cost phải được thiết kế từ đầu.
- Fabric và Databricks là phương tiện; câu hỏi then chốt là workload nào chạy ở đâu và vì sao.
- Trích: "Pipeline chạy thành công không đồng nghĩa với dữ liệu đúng."
- Trích: "Architecture không bắt đầu từ technology. Architecture bắt đầu từ business requirements, workload…"

**12. Liên kết với các bài khác**
- Bài mở đầu, đặt khung tham chiếu (6 lớp + 6 yếu tố) cho cả series.
- Mục 4 và 5 là phần giới thiệu trước cho Bài 2 (Ingestion) và Bài 3 (Lake/Lakehouse/Warehouse).
- Reference architecture đã dùng Bronze/Silver/Gold, sẽ được đào sâu ở bài Medallion.
- Mục "Fabric và Databricks nằm ở đâu?" mở đường cho bài Fabric vs Databricks.
- Kịch bản chứng khoán dẫn tới Securities Data Platform Case Study ở cuối series.
- Bài kế tiếp được nêu tên: "Data Ingestion Architecture: Batch, Incremental, CDC & Real-time".

---

## Bài 2: Data Ingestion Architecture – Batch, Incremental, CDC & Real-time
*Tiêu đề gốc: "Modern Data Platform - Bài 2: Data Ingestion Architecture – Batch, Incremental, CDC & Real-time" · Đăng 2026-10-02 · 2 bảng dạng ảnh*

Mục lục (H2): 1. Data Ingestion Architecture – Đừng bắt đầu bằng câu hỏi dùng Batch hay CDC | 2. Full Load và Incremental Load – Khi nào nên sử dụng? | 3. Watermark và bài toán DELETE – Những điểm dễ gây mất dữ liệu | 4. CDC và Real-time/Streaming – Capture thay đổi và xử lý liên tục | 5. So sánh ingestion strategy và lựa chọn theo từng loại dữ liệu | 6. Reliability – Replay, Checkpoint, Idempotency và xử lý lỗi | 7. Schema Evolution – Điều gì xảy ra khi Source thay đổi cấu trúc? | 8. Framework lựa chọn Batch, Incremental, CDC hay Streaming | 9. Áp dụng vào Fabric, Databricks và hệ thống thực tế | 10. Kết luận *(thêm mục H4 "Bài tiếp theo")*

**1. Bối cảnh & vấn đề mở đầu**
- Bài nhắc lại 6 lớp của Bài 1. Ingestion là một trong những lớp đầu tiên cần thiết kế cẩn thận.
- Dù phía sau có Lake, Lakehouse, DW, Spark, Fabric, Databricks hay Power BI, nếu dữ liệu đi vào **sai, chậm hoặc không đáng tin cậy** thì toàn bộ hệ thống phía sau đều bị ảnh hưởng.
- Câu hỏi trung tâm: "Dữ liệu từ Source sẽ đi vào Data Platform bằng cách nào?"

**2. Luận điểm cốt lõi**
Batch, Incremental, CDC và Real-time không nằm trên cùng một trục. Một trục là *tần suất/latency*, trục kia là *cách lấy thay đổi*. Ingestion strategy phải được chọn **theo từng nguồn hoặc từng bảng**, dựa trên khả năng của source, latency mà business thật sự cần, khối lượng dữ liệu và yêu cầu vận hành, phục hồi (replay, checkpoint, idempotency). Kiến trúc tốt không phải kiến trúc phức tạp nhất, mà là kiến trúc đưa dữ liệu vào đúng, đủ, đúng thời điểm và phục hồi được một cách đáng tin cậy.

**3. Khái niệm chính**
- **Trục 1 – tần suất xử lý**: `Batch → Micro-batch → Near Real-time → Real-time/Streaming`.
- **Trục 2 – cách lấy dữ liệu mới hoặc thay đổi**: `Full Load → Incremental Load → CDC`. Full Load và Incremental là *chiến lược nạp*; CDC là *phương pháp capture thay đổi*.
- **Full Load**: mỗi lần chạy lấy toàn bộ dữ liệu trong phạm vi đã xác định.
- **Incremental Load**: chỉ lấy dữ liệu mới hoặc thay đổi kể từ lần chạy trước. Chỉ đáng tin cậy khi source có cơ chế tracking.
- **Cột/cơ chế tracking**:
  - `UPDATED_AT`: thời điểm cập nhật bản ghi.
  - `CREATED_AT`: chỉ phát hiện bản ghi mới, **không bắt được UPDATE**.
  - `VERSION`: phiên bản hoặc số thứ tự thay đổi.
  - `SEQUENCE_ID`: mã tăng dần, nếu phù hợp với ngữ nghĩa dữ liệu.
  - `SCN`: System Change Number của Oracle.
  - `LSN`: Log Sequence Number trong SQL Server hoặc hệ thống liên quan.
  - Các cơ chế này không thay thế được cho nhau; SCN và LSN phải dùng theo cơ chế của từng database.
- **Watermark**: mốc tiến độ dùng để xác định dữ liệu cần lấy ở lần chạy sau. Được lưu trong bảng `pipeline_metadata` (source, table_name, last_watermark, status, run_time, row_count) để theo dõi tiến độ, chạy tiếp từ lần trước và hỗ trợ recovery.
- **CDC (Change Data Capture)**: thu thập INSERT/UPDATE/DELETE từ transaction log hoặc cơ chế tương đương, thay vì quét cả bảng hay chỉ dựa vào `UPDATED_AT`. CDC sinh ra **change event**; tùy công nghệ và cấu hình, event có thể chứa giá trị mới, giá trị cũ, metadata của transaction và vị trí thay đổi trong log.
- **Streaming**: tiếp nhận và xử lý liên tục, với độ trễ thấp.
- **Các cơ chế phục hồi**: Offset, Checkpoint, Watermark, Replay, Retry, Dead Letter.
- **Idempotency**: "đặc tính giúp việc thực hiện lại một thao tác không tạo ra các tác động không mong muốn lặp đi lặp lại".
- **Quarantine / Dead Letter Queue**: nơi cách ly dữ liệu lỗi để điều tra.
- **Schema Evolution**: gồm Schema Detection, Schema Validation, Schema Evolution, Backward Compatibility, Breaking Changes, và quy trình thông báo/phê duyệt thay đổi.
- **Khác**: soft delete (`IS_DELETED`), snapshot comparison, late-arriving data.

**4. Kiến trúc, pattern & quy trình**
- **Tổ hợp hai trục**: Batch + Full Load | Batch + Incremental | Batch + CDC | Streaming + Event | Streaming + CDC.
- **Vòng đời watermark**: đọc `last_watermark` → `SELECT * FROM <table> WHERE UPDATED_AT > :last_watermark` → ghi vào target → **chỉ sau khi thành công** mới cập nhật watermark và metadata.
- **Cùng một cơ chế capture, khác yêu cầu latency**:
  - CDC + Batch: `Oracle → CDC → Change Log → (mỗi 1 giờ) → Data Platform`.
  - CDC + Streaming: `Oracle → CDC → Kafka → Streaming Processing → Lakehouse`.
- **Platform đa pattern**:
  - Batch cho Reference Data và Customer Master.
  - CDC cho Order/Trade và Account Changes.
  - Streaming cho Market Events và Price/Volume.
  - Tất cả cùng đổ vào Data Platform.
- **Happy path so với production**:
  - Happy path: `Source → Extract → Transform → Load → SUCCESS`.
  - Production có thể gặp: Connection failure, Timeout, Duplicate data, Schema change, Missing data, Late-arriving data, Corrupt data → Error Handling.
- **Thành phần ingestion cần có**: retry & backoff, monitoring & alerting, logging, checkpoint & recovery, replay, DQ validation, quarantine/DLQ, idempotency & deduplication.
- **Mapping khái niệm**: `Source → Ingestion (Batch/Incremental/CDC/Streaming) → Lake/Lakehouse → Processing → Serving`.

**5. Framework ra quyết định & so sánh**

Bảng ảnh 1 – Mô hình theo độ trễ (tác giả lưu ý đây là phân loại khái quát, không phải ngưỡng chuẩn):

| Mô hình | Đặc điểm điển hình |
|---|---|
| Batch | Xử lý theo lịch, có thể cách nhau hàng giờ hoặc hàng ngày |
| Micro-batch | Gom thành các đợt nhỏ, xử lý cách nhau vài giây hoặc vài phút |
| Near Real-time | Hướng tới độ trễ thấp, thường ở mức giây hoặc phút |
| Real-time/Streaming | Tiếp nhận và xử lý liên tục; có thể hướng tới độ trễ dưới 1 giây, tùy hệ thống |

Bảng ảnh 2 – So sánh ingestion strategy (các strategy không loại trừ nhau):

| Strategy | Cách hoạt động | Ưu điểm | Hạn chế |
|---|---|---|---|
| Full Load | Lấy toàn bộ dữ liệu | Đơn giản, dễ đối chiếu | Tốn tài nguyên khi dữ liệu lớn |
| Incremental | Lấy phần mới hoặc thay đổi | Giảm lượng dữ liệu phải đọc | Cần cơ chế tracking đáng tin cậy |
| CDC | Capture thay đổi từ source | Theo dõi INSERT, UPDATE, DELETE khi được hỗ trợ | Cấu hình và vận hành phức tạp hơn |
| Streaming | Xử lý luồng dữ liệu liên tục | Phù hợp workload cần độ trễ thấp | Đòi hỏi quản lý trạng thái và vận hành cẩn thận |

- **Full Load chi tiết**:
  - Ưu điểm: đơn giản, dễ triển khai; dễ kiểm tra và đối chiếu; ít phụ thuộc vào tracking của source; dễ xây quy trình nạp lại khi có sự cố.
  - Nhược điểm: tốn băng thông và tài nguyên; tăng thời gian ingestion; tăng tải lên source DB; kém hiệu quả với bảng lớn nếu chạy thường xuyên.
  - Đây là trade-off "Simple Architecture vs Complex Architecture": kiến trúc đơn giản, dễ vận hành đôi khi tốt hơn kiến trúc phức tạp mà không giải quyết thêm vấn đề gì đáng kể.
- **Các cách xử lý DELETE**:
  - CDC có capture DELETE.
  - Soft delete (`IS_DELETED`).
  - Đối chiếu toàn bộ source và target theo lịch.
  - Snapshot comparison.
  - Cơ chế tracking khác mà source hỗ trợ.
  - Không có phương án dùng được cho mọi hệ thống; cần xét khả năng của source, khối lượng dữ liệu và yêu cầu nhất quán.
- **Latency theo use case**:
  - Daily Management Report → Batch.
  - Risk Monitoring → Near Real-time.
  - Một số workload Trading hoặc Fraud Detection → độ trễ thấp hơn có thể là bắt buộc.
  - Nếu Risk chỉ cần cập nhật mỗi 5 phút, API polling hoặc micro-batch là đủ. Nếu cần phản ứng dưới 1 giây, mới cần event streaming.
  - Streaming không tự động bảo đảm end-to-end latency thấp; latency còn phụ thuộc ingestion, processing, network, storage và serving.
- **Framework 4 bước** (chi tiết ở mục 10).

**6. Best practices / nguyên tắc thiết kế**
- Luôn tách hai trục. Hai nguyên tắc: "**CDC không đồng nghĩa với Real-time**" và "**Batch không đồng nghĩa với Full Load**".
- Chọn strategy theo từng nguồn hoặc từng bảng, và kết hợp nhiều pattern trong cùng một platform.
- **Thiết kế watermark đúng**:
  - Timestamp được tạo lúc bắt đầu xử lý hay lúc commit?
  - Có transaction cập nhật chậm không? Có nhiều bản ghi trùng timestamp không? Clock giữa các hệ thống có đồng bộ không? Có dữ liệu đến muộn không?
  - Chỉ cập nhật watermark **sau khi** ghi target thành công.
  - Giảm rủi ro bằng khoảng thời gian chồng lấn (overlap) khi truy vấn, kết hợp upsert hoặc dedup ở target. Cách này không tự giải quyết được mọi vấn đề về transaction.
- Workload cần capture chính xác nên cân nhắc **CDC dựa trên transaction log** nếu source hỗ trợ. CDC đặc biệt hữu ích với bảng transaction lớn.
- Latency là business requirement: hỏi xem business *thực sự* cần độ trễ bao nhiêu.
- **Reliability**:
  - Công thức: `Retry + Idempotency + Deduplication`.
  - Dùng khóa nghiệp vụ hoặc event ID duy nhất.
  - Dùng UPSERT/MERGE phù hợp với target.
  - Theo dõi ID hoặc vị trí event đã xử lý.
  - Thiết kế checkpoint và cơ chế commit phù hợp.
  - Kiểm soát thứ tự và phiên bản của các thay đổi.
- **Phân loại lỗi**: lỗi kết nối tạm thời thì retry; dữ liệu sai định dạng hoặc schema không tương thích thì cách ly để điều tra. Mục tiêu là "không âm thầm bỏ mất dữ liệu" và không để dữ liệu lỗi lan sang các lớp sau.
- **Chiến lược schema** phải xác định:
  - Thay đổi nào được tự động chấp nhận (ví dụ thêm cột nullable).
  - Thay đổi nào cần kiểm tra hoặc phê duyệt.
  - Dữ liệu được xử lý thế nào khi schema không tương thích.
  - Cách phục hồi và xử lý lại sau khi sửa pipeline.
  - Với CDC, Kafka, event streaming và Lakehouse, cần quản lý schema chặt để producer, consumer và downstream không mất tương thích.
- Xác định strategy trước rồi mới mapping sang nền tảng. Không chọn công cụ chỉ vì nó hỗ trợ một tính năng nào đó.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Bắt đầu bằng câu hỏi "Batch hay CDC"; trộn lẫn hai trục.
- Mặc định Full Load là kém, hoặc ngược lại, dựng CDC phức tạp cho bảng tham chiếu nhỏ.
- Chạy Full Load thường xuyên trên bảng lớn.
- Dùng `CREATED_AT` để bắt UPDATE; làm incremental trên bảng không có tracking.
- Đẩy watermark lên trước khi transaction được commit/phản ánh, hoặc trước khi ghi target thành công, dẫn đến **mất dữ liệu**.
- Quên DELETE khi làm incremental theo timestamp, khiến source và target lệch nhau.
- "Đừng biến mọi bài toán thành Real-time." Không ép toàn hệ thống thành "Everything Batch" hay "Everything Streaming".
- Chỉ INSERT mà không chống trùng; tin rằng chỉ có checkpoint là đủ để không trùng dữ liệu.
- Không có cơ chế replay, hoặc source không còn giữ dữ liệu, khiến recovery rất khó.
- Retry vô hạn với mọi loại lỗi.
- Tự động chấp nhận mọi schema change: đổi kiểu dữ liệu, đổi ý nghĩa trường, xóa cột mà downstream đang dùng.
- Quyết định "chuyển sang CDC" khi chưa kiểm tra source có hỗ trợ hay không.
- Áp một pattern duy nhất cho toàn hệ thống.

**8. Ví dụ minh họa**
- **Full Load trên bảng lớn**: bảng Customer trong Oracle có 10 triệu bản ghi; mỗi ngày đọc lại toàn bộ dù chỉ vài nghìn bản ghi thay đổi.
- **Full Load hợp lý**: PRODUCT, COUNTRY, BRANCH, SECURITY_MASTER, khoảng 10.000 bản ghi, ít cập nhật. Với các bảng này, CDC "không mang lại lợi ích tương xứng".
- **Incremental trên ORDERS**:
  - Cột: ORDER_ID, CUSTOMER_ID, ORDER_DATE, UPDATED_AT, STATUS.
  - Watermark lần trước: `2026-09-28 01:00:00`.
  - Truy vấn theo `UPDATED_AT > :last_watermark` chỉ phải xử lý **25.000** bản ghi thay vì 10.000.000.
- **Bảng thiếu tracking**: chỉ có ORDER_ID, CUSTOMER_ID, STATUS, AMOUNT, nên không biết bản ghi nào vừa được UPDATE. Cần cân nhắc CDC hoặc phương án khác.
- **Bản ghi metadata**: CUSTOMER, last_watermark `2026-09-28 02:00:00`, status SUCCESS, row_count 125000.
- **Watermark gây mất dữ liệu**: một transaction bắt đầu trước 01:00:00 nhưng commit sau 01:00:10. Nếu watermark đã vượt mốc trước khi transaction được phản ánh, bản ghi bị bỏ sót.
- **DELETE**: CUSTOMER có ID 1–5, xóa ID=3. Source còn 1, 2, 4, 5 nhưng target vẫn giữ 1–5.
- **Change event CDC**:
  - Số dư khách hàng giảm từ 10.000.000đ xuống 8.000.000đ, tạo event `{operation: UPDATE, customer_id: 100, balance: 8000000}`.
  - Khi xóa: `{operation: DELETE, customer_id: 100}`.
- **Market data**: giá VHM 125.5 → 126.0 → 126.5 → Risk/Alert.
- **Áp dụng cho công ty chứng khoán** (nguồn: Oracle Core, Tibero, Market Data API, Customer API):

| Dữ liệu | Quy mô/đặc điểm | Strategy | Điều kiện |
|---|---|---|---|
| Customer Master | 10 triệu dòng | Batch + Incremental | Khi `UPDATED_AT` đáng tin cậy; nếu không có change tracking thì cần phương án khác |
| Security Master | 50.000 dòng | Daily Full Load | Không lớn, không cần cập nhật liên tục |
| Order/Trade | Bảng giao dịch | CDC + Batch hoặc CDC + Near Real-time | Tùy nhu cầu của Risk, Position, P&L, Monitoring |
| Market Data (Price/Volume/Index) | Event liên tục | Streaming hoặc API Polling | Streaming chỉ khi thực sự cần độ trễ thấp |

- **Replay với Kafka**: các event 1001–1005; pipeline xử lý đến 1003 thì crash. Khi khởi động lại, tiếp tục từ 1004 nếu checkpoint đã được ghi nhận an toàn.
- **Idempotency**: ORDER_ID=1001 đã được ghi vào target nhưng pipeline crash trước khi ghi checkpoint. Retry gửi lại event; nếu chỉ INSERT, target sẽ có hai dòng 1001.
- **Schema change**: bảng ORDER (ORDER_ID, CUSTOMER_ID, AMOUNT, STATUS) được thêm cột CHANNEL, hoặc AMOUNT đổi từ DECIMAL sang BIGINT. Pipeline có thể chạy tiếp, tự thích nghi hoặc thất bại.
- **Hệ thống thực tế `Tibero → PySpark → MinIO → StarRocks → Superset`**:
  - Một số bảng Tibero không có CDC và không có `UPDATED_AT`, nên không thể quyết định chuyển sang CDC khi chưa kiểm tra khả năng của source.
  - Phân loại: Small Reference Table → Full Load; Large Table có `UPDATED_AT` đáng tin cậy → Incremental; Transaction Table → CDC nếu source và kiến trúc hỗ trợ; Market Data → Streaming hoặc API Polling.
  - Bảng lớn không có tracking: đánh giá snapshot comparison, đối chiếu dữ liệu, khả năng đọc log hoặc cơ chế khác mà source thật sự hỗ trợ.

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle**: nguồn CDC qua transaction log; SCN. **SQL Server**: LSN. **Tibero**: nguồn có bảng không có CDC/`UPDATED_AT`. **Oracle Core, Customer API, Market Data API**: các nguồn trong kịch bản chứng khoán.
- **Kafka**: kênh chuyển CDC/event cho streaming; ví dụ replay theo vị trí event.
- **Lakehouse**: đích của streaming processing.
- **Microsoft Fabric**: kết hợp các thành phần ingestion, orchestration và processing.
- **Databricks**: cơ chế đọc dữ liệu, xử lý batch hoặc streaming, Spark-based processing.
- **PySpark, MinIO, StarRocks, Superset**: thành phần của kiến trúc hiện hữu trong ví dụ. [Ghi chú: bài không mô tả vai trò chi tiết; theo vị trí trong luồng, có thể hiểu lần lượt là xử lý, lưu trữ object, kho phân tích và BI.]
- Spark, Data Lake/Lakehouse/DW, Power BI: được nhắc ở phần mở đầu như các thành phần phía sau.

**10. Checklist / câu hỏi thiết kế**
- **Framework 4 bước**:
  1. *Latency*: `Hours/Days → Batch`; `Seconds/Minutes → Micro-batch/Near Real-time`; `Very Low Latency → Evaluate Streaming`. Đây chỉ là định hướng ban đầu.
  2. *Tracking* (khi Batch đủ đáp ứng): `Data Volume? Small → Full Load; Large → Reliable Change Tracking? Yes → Incremental / No → Evaluate CDC, Snapshot hoặc phương án khác`. Nếu source hỗ trợ CDC thì CDC cũng dùng được cho batch hoặc near real-time; cây quyết định không phải quy tắc bắt buộc.
  3. *Khả năng của source*: có CDC không? Đọc được transaction log không? Có `UPDATED_AT` hoặc change tracking đáng tin cậy không? Có thể snapshot hoặc full scan không? Có giới hạn tải lên source không? Có yêu cầu giữ thứ tự transaction không?
  4. *Yêu cầu vận hành*: có cần replay không? Xử lý được dữ liệu trùng không? Đồng bộ DELETE thế nào? Schema thay đổi thì sao? Có cần audit và đối chiếu không? Khôi phục sau failure được không? Chi phí triển khai và vận hành có phù hợp không?
- **8 câu hỏi bắt buộc dù dùng Fabric hay Databricks**: Data đến từ đâu? Thay đổi như thế nào? Latency yêu cầu bao nhiêu? Volume bao nhiêu? Có DELETE không? Có replay không? Schema evolution xử lý ra sao? Failure khôi phục thế nào?
- **4 câu hỏi khởi đầu (kết luận)**:
  1. Data đến từ đâu: DB, API, file hay event?
  2. Data thay đổi thế nào: Full Load, Incremental hay CDC?
  3. Business cần dữ liệu nhanh đến mức nào: Batch, Near Real-time hay Streaming?
  4. Pipeline gặp sự cố thì sao: Retry, Checkpoint, Replay, Idempotency, Recovery?
- **Mẫu tổng hợp**: `Reference Data → Batch + Full Load` | `Large Master Data → Batch + Incremental` | `Transaction Data → CDC + Near Real-time` | `Market Events → Streaming`.

**11. Kết luận & key takeaways**
- Ingestion quyết định dữ liệu được thu thập, đồng bộ, kiểm soát và khôi phục như thế nào; không chỉ là "lấy rồi ghi".
- Hai trục độc lập: tần suất và cách capture.
- Incremental phụ thuộc tracking; watermark và DELETE là hai điểm dễ gây mất hoặc lệch dữ liệu.
- "Không phải dữ liệu nào cũng cần CDC", cũng không phải dữ liệu nào cũng cần Streaming hay Full Load. Hãy kết hợp pattern theo từng nguồn.
- Reliability (replay, checkpoint, idempotency, xử lý lỗi, quản lý schema) là điều phân biệt một pipeline production với pipeline thử nghiệm.
- Quyết định công nghệ đến sau cùng.
- Trích: "Real-time là một business requirement, không phải mặc định là một technology requirement."
- Trích: "Một Data Ingestion Architecture tốt không phải kiến trúc phức tạp nhất, mà là kiến trúc đưa dữ liệu vào đúng, đủ, đúng thời điểm…"

**12. Liên kết với các bài khác**
- Đào sâu lớp Ingestion trong mô hình 6 lớp của Bài 1 (mở rộng mục 4 của Bài 1).
- Đặt nền cho các bài Batch/CDC/Streaming và Governance/Operations trong roadmap của series.
- Bài kế tiếp được nêu tên: **"Data Lake, Lakehouse & Data Warehouse – Khác nhau ở đâu và khi nào sử dụng?"**, kèm OneLake, Lakehouse và Warehouse của Fabric.

---

## Bài 3: Data Lake, Lakehouse & Data Warehouse – Hiểu đúng Storage Architecture ?
*Tiêu đề gốc: "Modern Data Platform - Bài 3: Data Lake, Lakehouse & Data Warehouse – Hiểu đúng Storage Architecture ?" · Đăng 2026-10-03 · 2 bảng dạng ảnh*

Mục lục (H2): 1. Storage Architecture: Tách lưu trữ khỏi xử lý dữ liệu | 2. Data Lake: Lưu trữ dữ liệu linh hoạt ở quy mô lớn | 3. Data Warehouse: Dữ liệu được mô hình hóa cho Analytics và BI | 4. Data Lakehouse: Kết hợp lưu trữ linh hoạt với quản lý dữ liệu dạng bảng | 5. So sánh Data Lake, Lakehouse và Data Warehouse | 6. Medallion Architecture: Bronze, Silver và Gold nằm ở đâu? | 7. Microsoft Fabric: OneLake, Lakehouse và Warehouse | 8. Databricks và quyết định chọn nền tảng | 9. Thiết kế Storage Architecture thực tế: Tránh copy dữ liệu không cần thiết | 10. Kết luận

**1. Bối cảnh & vấn đề mở đầu**
- Bài 2 đã trả lời câu hỏi dữ liệu vào platform bằng cách nào (Batch, Incremental, CDC, Streaming). Câu hỏi tiếp theo: "Dữ liệu sẽ được lưu ở đâu và tổ chức như thế nào?"
- Người học gặp Data Lake, Lakehouse và Data Warehouse; khi vào Fabric và Databricks lại gặp thêm OneLake, Lakehouse, Warehouse, Delta Lake.
- Các khái niệm này liên quan nhưng **không đồng nghĩa**. Phải hiểu vai trò của từng thành phần trước khi thiết kế.

**2. Luận điểm cốt lõi**
Tác giả cho rằng phải tách storage khỏi processing engine và khỏi sản phẩm cụ thể. Ba mô hình có vai trò khác nhau:
- **Lake:** lưu trữ linh hoạt, dữ liệu raw, quy mô lớn.
- **Lakehouse:** quản lý dữ liệu dạng bảng trên nền lake, gồm table, schema, metadata, transaction và versioning.
- **Warehouse:** dữ liệu được mô hình hóa cho analytics và BI.

Không mô hình nào luôn tốt hơn. Một Enterprise Data Platform thường kết hợp cả ba theo vai trò, đồng thời giảm bản sao không cần thiết và quản lý vòng đời dữ liệu.

**3. Khái niệm chính**
- **Storage và Processing:**
  - Storage trả lời câu hỏi: "Dữ liệu được lưu ở đâu, dưới dạng gì và được quản lý như thế nào?"
  - Processing trả lời câu hỏi: "Dữ liệu được xử lý bằng engine nào?"
- **Data Lake:** lớp lưu trữ quy mô lớn, chứa nhiều định dạng: CSV, JSON, XML, Parquet và các định dạng cột khác, database extracts, logs, events. Thường giữ dữ liệu ở dạng raw hoặc chỉ biến đổi tối thiểu trong giai đoạn đầu. Điểm mạnh là không bắt buộc đưa mọi dữ liệu vào schema quan hệ ngay từ đầu.
- **Data Swamp:** Data Lake liên tục nhận file nhưng không quản lý schema, nguồn gốc, chất lượng, quyền truy cập và vòng đời. Kết quả là "nơi có nhiều dữ liệu nhưng khó tìm kiếm và khó tin cậy".
- **Data Warehouse:** dữ liệu có cấu trúc, được tổ chức và mô hình hóa (dimensional modeling với Fact và Dimension) để phục vụ phân tích. Không nhất thiết phải nằm trên một database server truyền thống.
- **Data Lakehouse:** đưa khả năng quản lý và truy vấn dữ liệu có cấu trúc lên nền lưu trữ kiểu lake.
  - Thường cung cấp table, schema, metadata, transaction và versioning.
  - **Không đơn giản là Data Lake + SQL.** SQL chỉ là một cách truy cập. Phần quan trọng là quản lý metadata, tính nhất quán khi ghi, khả năng cập nhật bảng và quản lý phiên bản.
- **Table format (Delta Lake, Apache Iceberg, Apache Hudi):** biến các file Parquet rời rạc trên Object Storage, cộng với transaction log, thành một bảng được quản lý. Đây là công nghệ liên quan, không đồng nghĩa với toàn bộ kiến trúc Lakehouse.
- **Medallion Architecture:** cách tổ chức các tầng dữ liệu theo mức độ xử lý và mức sẵn sàng sử dụng. Đây **không phải một loại storage riêng** và thường được triển khai trên Lakehouse.
  - **Bronze (raw hoặc gần raw):** dữ liệu vừa ingest, như Oracle extracts, Tibero extracts, API events. Giữ dữ liệu nguồn cùng thông tin cần để truy vết, đối soát và xử lý lại.
  - **Silver (cleaned & standardized):** deduplication, validation, chuẩn hóa kiểu dữ liệu, áp dụng các quy tắc xử lý chung.
  - **Gold (business-ready):** tổ chức theo mục đích nghiệp vụ như Trade Analytics, Customer 360, Portfolio, P&L, Risk Metrics.
- **OneLake:** lớp Data Lake thống nhất cho Fabric tenant, không chỉ là "thư mục chứa file". Mục tiêu là tránh việc mỗi workload có storage silo riêng và phải sao chép dữ liệu liên tục.
- **Fabric Lakehouse:** workload làm việc với files và tables, thường gắn với Delta Lake và Data Engineering.
- **Fabric Warehouse:** workload cho dữ liệu có cấu trúc, SQL analytics và BI.
- **Zero-copy:** hướng giảm các bản sao không cần thiết, nhưng "không phải mục tiêu tuyệt đối".
- **Data Lifecycle Management:** chia dữ liệu thành Hot, Warm và Cold/Archive theo nhu cầu hiệu năng và chi phí.

**4. Kiến trúc, pattern & quy trình**
- **Tách engine khỏi storage:** `Processing (SQL | Spark | Python) → Storage (Lake | Lakehouse | Warehouse)`. Nhiều engine có thể dùng chung các loại storage.
- **Nội dung của Data Lake:** CSV, JSON, Parquet, Logs, API, DB Extracts.
- **Bố cục Bronze trong lake (ví dụ chứng khoán):**
  - `/bronze/oracle/{customer, account, order}`
  - `/bronze/tibero/{portfolio, margin}`
  - `/bronze/market/{price, volume}`
  - Lưu dạng Parquet hoặc JSON tùy nguồn. Ở bước này chưa cần Join, Normalize, Aggregate hay áp dụng toàn bộ business rules.
- **Luồng Warehouse:** `Clean → Transform → Join → Model → Aggregate → Data Warehouse → BI/Reporting`.
- **Lakehouse:** `Data Lake (Flexible Storage, Large-scale, Raw/Semi-structured) → Lakehouse (Tables + Schema + Transactions) → Analytics/SQL`.
- **Table format:** `Object Storage → {Parquet Files + Transaction Log} → Delta Table`, thay vì quản lý các file rời như `customer/part-001.parquet`, `part-002.parquet`, `part-003.parquet`.
- **Medallion:** `Oracle/Tibero/Market API → Bronze → (Clean/Deduplicate/Validate) → Silver → (Business Rules/Aggregation/Modeling) → Gold → {BI, AI/ML, Apps}`.
  - Đây là "backbone phổ biến" của Modern Data Platform.
  - Tuy vậy, không phải mọi dữ liệu đều phải đi qua cả ba tầng trong một pipeline duy nhất, và Gold không bắt buộc phải nằm trong một sản phẩm cụ thể.
- **Fabric:** `Microsoft Fabric → OneLake → {Lakehouse, Warehouse, Other} → Analytics → Power BI`.
- **Databricks:** `Cloud Storage → Delta Lake → {Spark, SQL, ML/AI} → Analytics`. Hướng tới việc kết hợp Data Engineering, Analytics, Data Science, ML và AI trên một nền dữ liệu chung.
- **Chuỗi copy truyền thống:** `Oracle → ETL Server → Data Lake → ETL → Data Warehouse → Data Mart → BI`. Mỗi bước có thể tạo thêm một bản sao dữ liệu.
- **Lifecycle:**
  - Dữ liệu giao dịch gần hiện tại → Hot.
  - Dữ liệu phân tích lịch sử → Warm.
  - Dữ liệu lưu giữ dài hạn → Cold/Archive.
- **Kiến trúc tổng hợp (phần kết luận):** `Data Sources → Ingestion (Batch/CDC/Streaming) → Storage Foundation (Lake | Lakehouse | Warehouse) → Processing → Bronze/Silver → Gold → Semantic/BI/AI`.

**5. Framework ra quyết định & so sánh**

Bảng ảnh 1 – So sánh ở mức kiến trúc tổng quát. Tác giả lưu ý đây không phải quy tắc tuyệt đối cho mọi sản phẩm.

| Tiêu chí | Data Lake | Data Lakehouse | Data Warehouse |
|---|---|---|---|
| Mục tiêu chính | Lưu trữ dữ liệu linh hoạt | Lưu trữ và quản lý dữ liệu dạng bảng trên nền tảng lake | Phân tích dữ liệu có cấu trúc |
| Dữ liệu | Structured, semi-structured và file khác | Thường tập trung vào dữ liệu dạng bảng, có thể hỗ trợ nhiều kiểu dữ liệu | Chủ yếu dữ liệu có cấu trúc phục vụ analytics |
| Schema | Linh hoạt, có thể áp dụng khi đọc hoặc xử lý | Quản lý theo khả năng của table format và engine | Schema và mô hình dữ liệu được quản lý chặt chẽ |
| Transaction | Không có sẵn ở cấp file theo nghĩa transaction của bảng | Có thể hỗ trợ qua table format và engine | Thường do nền tảng Warehouse quản lý |
| Xử lý điển hình | Lưu raw data, archive, ingestion | Data engineering, transformations, analytics | SQL analytics, BI, reporting |
| Lưu ý | Cần metadata, catalog và governance | Cần hiểu khả năng tương thích của format, engine và catalog | Cần thiết kế mô hình và quản lý chi phí phù hợp |

Bảng ảnh 2 – Framework lựa chọn ở mức kiến trúc. Đây là định hướng, không phải quy tắc cứng.

| Nhu cầu chính | Hướng tiếp cận phù hợp |
|---|---|
| Lưu raw data, nhiều định dạng, quy mô lớn | Data Lake |
| Quản lý bảng dữ liệu trên nền tảng lake, Data Engineering và analytics | Lakehouse |
| SQL analytics, mô hình dữ liệu có cấu trúc, BI và reporting | Data Warehouse |
| Nhiều loại workload trong cùng Enterprise Data Platform | Kết hợp các mô hình theo vai trò |

- **Khi nào Warehouse đặc biệt phù hợp:** Management Reporting, Financial Reporting, Business Analytics, Dashboard và BI, SQL analytics trên dữ liệu có cấu trúc, mô hình dữ liệu được quản trị tập trung.
- **Lakehouse và Warehouse trong Fabric:** hai workload này có thể cùng tồn tại, không loại trừ nhau.

| | Fabric Lakehouse | Fabric Warehouse |
|---|---|---|
| Workload phù hợp | Data Engineering; Spark và xử lý quy mô lớn; transformations trên dữ liệu dạng lake; Data Science và lake-based analytics | Structured Analytics; SQL và reporting; Enterprise Data Warehouse; mô hình dữ liệu phục vụ BI |

  Nên chọn theo workload, mô hình dữ liệu, yêu cầu quản trị và cách phục vụ người dùng cuối, không chỉ theo tên sản phẩm.
- **Chọn nền tảng (Fabric, Databricks, kết hợp cả hai, hoặc phương án khác):**
  - Không so sánh chỉ bằng câu hỏi "bên nào có Lakehouse tốt hơn".
  - Bắt đầu từ Business Requirements: BI, Data Engineering, Data Science, AI/ML, Streaming, Governance, Existing Ecosystem.
  - Với tổ chức đã có hệ sinh thái BI, dữ liệu và quy trình vận hành, thì chi phí chuyển đổi, khả năng tích hợp và kỹ năng đội ngũ "quan trọng không kém danh sách tính năng".
- **Khi nào vẫn cần sao chép dữ liệu:**
  - Hiệu năng và tối ưu workload.
  - Cách ly workload hoặc môi trường.
  - Yêu cầu bảo mật và quyền truy cập.
  - Khôi phục và lưu giữ dữ liệu.
  - Cung cấp dữ liệu cho ứng dụng hoặc hệ thống bên ngoài.
- **Yếu tố lifecycle:** retention, lifecycle, cost, performance, compliance. Với dữ liệu tài chính, chính sách lưu giữ phải phù hợp với yêu cầu nghiệp vụ và quy định áp dụng cho tổ chức.

**6. Best practices / nguyên tắc thiết kế**
- **Phân biệt loại storage với công nghệ xử lý và với sản phẩm triển khai cụ thể.**
- Giữ dữ liệu gốc ở Lake hoặc Bronze để có thể xử lý lại khi business rules thay đổi hoặc khi cần điều tra sai lệch.
- Data Lake phải đi kèm quản trị: metadata, catalog, schema, nguồn gốc, chất lượng, quyền truy cập và vòng đời.
- Hiểu bài toán kiến trúc thay vì học thuộc tên công nghệ: làm sao biến file trong Object Storage thành bảng có thể quản lý, cập nhật và truy vấn một cách đáng tin cậy.
- Với Lakehouse, cần hiểu khả năng tương thích giữa format, engine và catalog. Với Warehouse, cần thiết kế mô hình và kiểm soát chi phí.
- Kết hợp theo vai trò: Lake giữ raw data, Lakehouse cho xử lý và quản lý bảng, Warehouse phục vụ BI/reporting cần mô hình dữ liệu phù hợp.
- Giảm bản sao không cần thiết và cho nhiều workload dùng chung nền dữ liệu khi phù hợp, nhưng vẫn chấp nhận copy khi có lý do chính đáng.
- Áp dụng Data Lifecycle Management (hot/warm/cold) theo retention, cost, performance và compliance.
- Một Data Platform tốt không chỉ lưu được dữ liệu mà còn phải quản lý metadata, chất lượng, quyền truy cập, lifecycle và cách dữ liệu được sử dụng.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Đánh đồng `Data Lake = Spark`, `Lakehouse = Databricks`, `Data Warehouse = SQL`, tức là trộn storage với processing.
- Liên tục đổ file vào lake mà không quản trị, dẫn đến **Data Swamp**.
- Bắt mọi loại dữ liệu (logs, events, JSON, documents, raw files) phải vào Warehouse trước khi sử dụng, khiến kiến trúc phức tạp và tốn kém.
- Hiểu Lakehouse là Data Lake + SQL, hoặc đồng nhất Delta, Iceberg, Hudi với toàn bộ kiến trúc Lakehouse.
- Coi Medallion là một loại storage, ép mọi dữ liệu đi qua đủ ba tầng trong một pipeline, hoặc cho rằng Gold phải nằm trong một sản phẩm cụ thể.
- Xem OneLake chỉ là thư mục chứa file, hoặc để mỗi workload tự xây storage silo rồi sao chép dữ liệu liên tục.
- Coi Lakehouse và Warehouse trong Fabric là loại trừ nhau, hoặc chọn theo tên sản phẩm.
- So sánh Fabric và Databricks chỉ qua câu hỏi "Lakehouse bên nào tốt hơn", bỏ qua hệ sinh thái hiện có, chi phí chuyển đổi và kỹ năng đội ngũ.
- Chuỗi ETL tạo nhiều bản sao, làm tăng dung lượng lưu trữ, network traffic, latency, số pipeline, điểm lỗi và công sức đối soát.
- Ngược lại, theo đuổi zero-copy như một mục tiêu tuyệt đối.
- Đối xử với mọi dữ liệu bằng cùng mức hiệu năng và chi phí lưu trữ.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **Lake/Bronze:** dữ liệu Oracle (customer, account, order), Tibero (portfolio, margin) và Market Data API (price, volume) được lưu theo thư mục nguồn dưới `/bronze/`, dạng Parquet hoặc JSON. Mục đích là giữ dữ liệu gốc để xử lý lại và điều tra sai lệch.
- **Warehouse:** Dimensions gồm DimCustomer, DimSecurity, DimAccount, DimDate. Facts gồm FactOrder, FactTrade, FactPosition, FactMargin.
- **Câu hỏi nghiệp vụ:** "doanh thu môi giới theo chi nhánh, tháng và nhóm khách hàng". Một Warehouse được mô hình hóa tốt giúp truy vấn này đơn giản và nhất quán hơn.
- **Medallion:**
  - Bronze: Oracle/Tibero extracts, API events.
  - Silver: dữ liệu đã dedup, validate và chuẩn hóa.
  - Gold: Trade Analytics, Customer 360, Portfolio, P&L, Risk Metrics, phục vụ BI, AI/ML và Apps.
- **Table format:** so sánh thư mục `customer/` chứa các file `part-001/002/003.parquet` rời rạc với một Delta Table có transaction log và metadata.
- **Lifecycle cho dữ liệu tài chính:** giao dịch gần hiện tại ở Hot, dữ liệu phân tích lịch sử ở Warm, dữ liệu lưu giữ dài hạn ở Cold/Archive, theo chính sách retention và quy định.

**9. Công nghệ/công cụ được nhắc tới**
- **SQL, Spark, Python:** processing engines, tách biệt khỏi storage.
- **CSV, JSON, XML, Parquet:** định dạng lưu trong lake; Parquet là định dạng dạng cột.
- **Object Storage / Cloud Storage:** nền lưu trữ file cho Lake và Lakehouse.
- **Delta Lake, Apache Iceberg, Apache Hudi:** table formats cung cấp khái niệm bảng, metadata, transaction log và versioning.
- **Microsoft Fabric:**
  - OneLake: lớp Data Lake thống nhất cho tenant.
  - Lakehouse: làm việc với files và tables, gắn với Delta Lake và Data Engineering.
  - Warehouse: SQL analytics và BI.
  - Power BI: lớp analytics/BI ở đầu ra.
- **Databricks:** tập trung mạnh vào Lakehouse architecture (Cloud Storage → Delta Lake → Spark/SQL/ML-AI).
- **Oracle, Tibero, Market Data API:** các nguồn dữ liệu trong ví dụ.
- **ETL Server, ETL, Data Mart:** các thành phần của chuỗi copy truyền thống.

**10. Checklist / câu hỏi thiết kế**
- **Framework lựa chọn (bảng ảnh 2):**
  - Raw data, nhiều định dạng, quy mô lớn → Lake.
  - Quản lý bảng trên lake, Data Engineering → Lakehouse.
  - SQL analytics, BI → Warehouse.
  - Nhiều loại workload → kết hợp theo vai trò.
- **Câu hỏi khi chọn nền tảng:**
  - Workload cần gì về BI, Data Engineering, Data Science, AI/ML, Streaming và Governance?
  - Hệ sinh thái hiện có là gì?
  - Chi phí chuyển đổi, khả năng tích hợp và kỹ năng đội ngũ ra sao?
- **Lý do chính đáng để giữ một bản sao:** hiệu năng, cách ly workload hoặc môi trường, bảo mật và quyền truy cập, khôi phục và lưu giữ, cung cấp cho hệ thống bên ngoài.
- **Lifecycle:** phân loại Hot/Warm/Cold theo retention, cost, performance và compliance.

**11. Kết luận & key takeaways**

Sáu điều tác giả tổng kết:
1. **Data Lake** ưu tiên khả năng lưu trữ linh hoạt ở quy mô lớn.
2. **Data Warehouse** tập trung vào dữ liệu được mô hình hóa cho analytical workloads.
3. **Data Lakehouse** kết hợp lưu trữ kiểu lake với khả năng quản lý và truy vấn dữ liệu dạng bảng.
4. **Delta Lake, Apache Iceberg, Apache Hudi** là table format hoặc công nghệ liên quan, không đồng nghĩa với toàn bộ kiến trúc Lakehouse.
5. **OneLake** là lớp Data Lake thống nhất trong Fabric. Lakehouse và Warehouse là các workload có thể cùng tồn tại trong hệ sinh thái này.
6. Một Data Platform tốt phải quản lý metadata, chất lượng, quyền truy cập, lifecycle và cách dữ liệu được sử dụng, không chỉ lưu được dữ liệu.

Hai trích dẫn tiêu biểu:
- "phân biệt loại storage với công nghệ xử lý và sản phẩm triển khai cụ thể."
- "zero-copy không phải mục tiêu tuyệt đối."

**12. Liên kết với các bài khác**
- Bài tự tóm tắt mạch series: Bài 1 nhìn tổng thể MDP; Bài 2 nói về cách dữ liệu đi vào (Batch, Incremental, CDC, Streaming); Bài 3 trả lời "dữ liệu được lưu trữ, quản lý và tổ chức như thế nào". Bài 2 và Bài 3 tạo thành "hai phần nền tảng: ingestion và storage architecture".
- Bài 3 đào sâu mục 5 (Storage Layer) của Bài 1, và thực hiện phần "Bài tiếp theo" mà Bài 2 đã hẹn (Lake/Lakehouse/Warehouse; OneLake/Lakehouse/Warehouse của Fabric).
- Medallion chỉ được giới thiệu ở mức khái niệm; nó đã xuất hiện trong reference architecture của Bài 1.
- So sánh chi tiết Fabric và Databricks được hẹn "trong một bài riêng của series".
- Bước tiếp theo theo lời tác giả: "tìm hiểu cách dữ liệu được tổ chức và xử lý xuyên suốt các tầng trong một Modern Data Platform". [Ghi chú: Bài 3 không nêu tên bài kế tiếp. Theo roadmap ở Bài 1, sau Lake/Lakehouse/Warehouse là "Microsoft Fabric & OneLake", rồi đến "Medallion Architecture".]

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **Xuất phát từ yêu cầu và workload, công nghệ tính sau.** Cả ba bài đều phản đối việc bắt đầu bằng chọn tool. Fabric hay Databricks chỉ là phương tiện; câu hỏi then chốt là "workload nào nên chạy ở đâu, và vì sao".
- **Tách bạch các khái niệm hay bị đánh đồng:**
  - CDC ≠ Real-time; Batch ≠ Full Load.
  - MDP ≠ Fabric hay Databricks.
  - Lake ≠ Spark; Lakehouse ≠ Databricks và ≠ Lake + SQL.
  - Medallion ≠ một loại storage; table format ≠ toàn bộ Lakehouse.
- **Không có lựa chọn luôn đúng, nên kết hợp theo vai trò.** Mỗi nguồn dùng ingestion pattern riêng; Lake, Lakehouse và Warehouse có thể cùng tồn tại. Mọi quyết định đều là architectural trade-off: đơn giản hay phức tạp, chi phí hay latency và hiệu năng, zero-copy hay copy có lý do.
- **Thiết kế cho sự cố và vận hành ngay từ đầu.** Retry, checkpoint, replay, idempotency, quarantine/DLQ, observability và đối soát DQ đều cần có. "Pipeline SUCCESS không có nghĩa là dữ liệu đúng"; không được để mất dữ liệu một cách âm thầm.
- **Ưu tiên giải pháp đơn giản khi đã đủ đáp ứng:**
  - Full Load cho bảng nhỏ.
  - Polling hoặc micro-batch thay cho streaming khi latency cho phép; không real-time hóa mọi thứ.
  - Quản lý lifecycle hot/warm/cold để kiểm soát chi phí.
- **Kịch bản công ty chứng khoán là ví dụ xuyên suốt:**
  - Nguồn: Oracle (Core), Tibero, Market Data API.
  - Thực thể: Customer, Account, Order/Trade, Portfolio, Margin, Position.
  - Backbone Bronze → Silver → Gold phục vụ BI, Risk và AI/ML.
  - Governance, DQ, Security và Cost đi xuyên suốt mọi lớp.


---

# Tóm tắt Bài 4–6 — Series "Modern Data Platform" (Duong Pham, Substack, 10/2026)

> Nguồn: bai04.md, bai05.md, bai06.md (đọc toàn văn) + 3 ảnh bảng của Bài 6 (images/bai06_01..03.png). Bảng bị Substack làm phẳng đã được dựng lại; bảng do người tóm tắt tự tổng hợp từ nội dung bài được ghi "(bảng tổng hợp)".

---

## Bài 4: Medallion Architecture - Tổ chức dữ liệu từ Raw Data đến Business Data Product
*Subtitle: "Data Platform Từ Lý thuyết đến Thực chiến" · Ngày đăng: 2026-10-04 · URL: https://duongpk9x.substack.com/p/data-platform-architect-bai-4 · Không có ảnh; 2 bảng dạng text đã dựng lại.*

Mục lục (H2): *(trong file, mục chính dùng heading `#`, mục con `##` ghi trong ngoặc)* 1. Medallion Architecture giải quyết vấn đề gì? | 2. Bronze – Lớp bảo vệ dữ liệu gốc | 3. Silver – Lớp xây dựng dữ liệu đáng tin cậy | 4. Gold – Lớp cung cấp Business Data Product | 5. Không phải dữ liệu nào cũng cần đi qua ba bản sao vật lý | 6. Thiết kế ranh giới giữa các layer trong Enterprise Data Platform | 7. Áp dụng Medallion Architecture vào một công ty chứng khoán (Bronze – dữ liệu theo nguồn; Silver – dữ liệu theo mô hình dùng chung; Gold – dữ liệu theo nhu cầu nghiệp vụ) | 8. Data Quality, Reprocessing và Idempotency – Những yêu cầu của Production (8.1 Data Quality; 8.2 Reprocessing; 8.3 Idempotency) | 9. Governance, Ownership và Data Lineage | 10. Từ Medallion Architecture đến Data Platform hoàn chỉnh | Kết luận

**1. Bối cảnh & vấn đề mở đầu**
- Các bài trước đã trình bày kiến trúc tổng thể Modern Data Platform, các phương pháp Data Ingestion và mô hình lưu trữ (Data Lake, Lakehouse, Data Warehouse). Câu hỏi tiếp theo: dữ liệu đã vào platform nên được tổ chức và biến đổi thế nào để vừa dễ quản lý, vừa đáng tin cậy, vừa phục vụ BI, Analytics, AI và ứng dụng nghiệp vụ?
- Nếu dồn mọi dữ liệu vào một khu vực rồi để từng team tự làm sạch, tự JOIN, tự định nghĩa business logic, sẽ phát sinh 6 vấn đề:
  - các team hiểu cùng một business entity theo những cách khác nhau;
  - cùng một chỉ số nhưng các báo cáo ra kết quả khác nhau;
  - AI và ứng dụng nghiệp vụ dùng các phiên bản dữ liệu không nhất quán;
  - khi dữ liệu sai, khó biết lỗi nằm ở source, ingestion hay transformation;
  - khi business rule đổi, không biết logic đang được triển khai ở đâu;
  - nhiều team liên tục xây lại những dataset đã tồn tại.

**2. Luận điểm cốt lõi**
Medallion (Bronze → Silver → Gold) không phải là tạo ba thư mục hay ba bản sao vật lý, mà là xác định **trách nhiệm, chất lượng và mục đích sử dụng** của dữ liệu ở từng mức trưởng thành — từ dữ liệu nguồn đến Business Data Product. Thiết kế phải dựa trên chất lượng dữ liệu, business meaning, ownership, security và workload, kèm các năng lực production xuyên suốt (Data Quality, Reprocessing, Idempotency, Governance, Lineage).

**3. Khái niệm chính**
- **Medallion Architecture**: mô hình tổ chức và hoàn thiện dữ liệu theo từng giai đoạn; mỗi layer là một mức độ trưởng thành khác nhau của dữ liệu.
- **Bronze (Raw Data)**: lớp gần Source nhất, theo nguyên tắc *"Preserve the source data"*: giữ dữ liệu sau ingestion, hạn chế thay đổi ý nghĩa, lưu đủ thông tin để truy vết hoặc xử lý lại. Ưu tiên traceability & recoverability; không phải nơi đặt phần lớn business logic.
- **Silver (Trusted Data / Conformed Models)**: dữ liệu đã làm sạch, chuẩn hóa, kiểm tra, dùng chung ở cấp enterprise. Tác giả coi đây là "một trong những lớp quan trọng nhất" vì nó biến dữ liệu rời rạc của từng nguồn thành dữ liệu nhất quán.
- **Gold (Business Data Product)**: dữ liệu được tổ chức để trả lời câu hỏi nghiệp vụ cụ thể, không phản ánh cấu trúc hệ thống nguồn.
- **Business Data Product**: ngoài dữ liệu còn phải có định nghĩa nghiệp vụ, chủ sở hữu (owner), chất lượng được kiểm soát, chính sách truy cập và cam kết cập nhật phù hợp với nhu cầu sử dụng.
- **Technical metadata (Bronze)**: `_source_system`, `_ingestion_time`, `_batch_id`, `_file_name`, `_record_hash` — cho biết bản ghi đến từ hệ thống nào, nạp lúc nào, thuộc batch nào.
- **Data conformance**: thống nhất khái niệm giữa các hệ thống. Không chỉ đổi tên cột mà còn phải mapping quy tắc định danh, vòng đời khách hàng, cách biểu diễn trạng thái và xử lý xung đột.
- **Logical layer vs Physical storage**: ranh giới về ý nghĩa, trách nhiệm, chất lượng vs cách dữ liệu thực sự được lưu, sao chép, tổ chức trên hạ tầng. Một layer logic không nhất thiết là một hệ thống lưu trữ hay bản sao riêng.
- **Materialize**: lưu vật lý kết quả của một bước biến đổi — chỉ làm khi có lý do rõ ràng.
- **Reprocessing**: tính lại Silver/Gold từ Bronze khi logic hoặc dữ liệu sai, không cần trích xuất lại toàn bộ từ nguồn.
- **Idempotency**: chạy lại pipeline vẫn cho kết quả đúng theo thiết kế, không phát sinh dữ liệu trùng.
- **Quarantine**: khu vực cách ly bản ghi lỗi (một trong các lựa chọn: từ chối / quarantine / chấp nhận tạm thời).
- **Data Governance / Ownership / Data Lineage**: trả lời các câu hỏi ai sở hữu, ai chịu trách nhiệm khi sai, dữ liệu nhạy cảm ở đâu, ai được đọc/sửa, chỉ số tính từ nguồn nào, thay đổi ảnh hưởng tới đâu.
- **as_of_time (thời điểm chốt dữ liệu)**: phần bắt buộc trong định nghĩa một Gold dataset.
- **MDM**: Silver không bắt buộc giải quyết toàn bộ Master Data Management, nhưng là nơi phù hợp để đặt quy tắc chuẩn hóa và mô hình dùng chung, làm nền cho quản trị dữ liệu sâu hơn.

**4. Kiến trúc, pattern & quy trình**
- **Luồng tổng quát**: `Source Systems → Data Ingestion → Bronze (Raw Data) →[Clean/Validate/Standardize/Dedup]→ Silver (Trusted Data) →[Business Modeling, Join/Aggregate]→ Gold (Business Data Product) → BI | Analytics | AI → Business Decisions`.
- **Bronze** lưu được:
  - raw tables trích từ database; JSON response từ API; CSV/Parquet/file;
  - event và CDC; snapshot theo thời điểm; metadata truy vết.
  - Có thể lưu snapshot định kỳ, dữ liệu CDC hoặc bản ghi theo batch.
  - Retention thiết kế theo yêu cầu audit, khả năng khôi phục, chi phí, quy định bảo mật — không phải giữ mọi bản sao vô thời hạn.
- **Silver** làm 5 nhóm việc: (1) cleansing; (2) data type standardization; (3) deduplication theo khóa, timestamp, version hoặc quy tắc cập nhật của nguồn; (4) data quality theo quy tắc nghiệp vụ; (5) data conformance. Kết quả là các dataset dùng chung `Silver.Customer/Account/Order/Trade/Position/Cash/Margin` cho BI, Risk, Marketing, AI — thay vì mỗi team tự xây một phiên bản Customer/Account.
- **Gold** phục vụ: BI & Dashboard; báo cáo tài chính, quản trị, tuân thủ; phân tích rủi ro; Data Science & ML; AI applications; ứng dụng nghiệp vụ & Data API. Một Gold dataset tốt được nhiều consumer tái sử dụng: `Gold.MarginRisk → Dashboard | Risk App | AI`.
- **Ranh giới enterprise** (mô hình logic, không bắt buộc tách thành database/cluster/hệ thống riêng):
  - Quy mô nhỏ: `EnterpriseData/{bronze, silver, gold}`, phân chia theo schema hoặc quy ước tên — đơn giản, dễ thử nghiệm, ít thành phần phải quản lý.
  - Khi lớn: `Bronze Zone (Source Data, Ingestion Metadata) | Silver Zone (Customer/Trading/Risk Domain) | Gold Zone (BI/Risk/Finance/AI Data Products)`.
- **Công ty chứng khoán (§7)**: `Oracle Core | Tibero | CRM | Market Data API → Data Ingestion → Bronze →[Clean/Validate/Deduplicate/Map]→ Silver →[Business Modeling, Calculation/Join]→ Gold → Power BI | Risk App | AI`.
- **Reprocessing** theo partition ngày: `Bronze[2026-09-19 … 2026-09-20 (Reprocess) … 2026-09-22] → Silver → Gold`.
- **Lineage**: `Oracle.CUSTOMER → Bronze.Customer → Silver.Customer → {Gold.Customer360 → Customer Dashboard; Gold.CustomerRisk → Risk Application}`.
- **Platform hoàn chỉnh (§10)**: `Business Systems (Database/APIs/Events) → Data Ingestion → Bronze (Raw/Source Data) →[Clean/Validate/Map]→ Silver (Trusted Data, Conformed Models) →[Business Logic/Modeling]→ Gold (Business Products) → BI/Analytics/AI → Business Value`.
  - Năng lực xuyên suốt mọi layer (không thuộc riêng layer nào): Data Quality, Data Lineage, Data Governance, Access Control, Monitoring & Alerting, Reprocessing, Idempotency, Metadata Management.
  - Chuỗi tóm tắt: `Raw Data → Trusted Data → Business Data → Business Decisions`.

**5. Framework ra quyết định & so sánh**

Bảng trong bài (dựng lại):

| Layer | Câu hỏi cần trả lời | Trách nhiệm chính |
|---|---|---|
| Bronze | Source đã cung cấp dữ liệu gì? | Lưu giữ dữ liệu gốc và lịch sử ingestion |
| Silver | Dữ liệu nào đã được làm sạch, chuẩn hóa và kiểm tra? | Xây dựng dữ liệu đáng tin cậy, có thể tái sử dụng |
| Gold | Business cần dữ liệu gì để ra quyết định? | Mô hình hóa, tổng hợp, cung cấp dữ liệu theo nhu cầu nghiệp vụ |

Kiểm tra chất lượng theo layer (từ sơ đồ §8.1):

| Bronze | Silver | Gold |
|---|---|---|
| Source schema; Ingestion completeness; Source metadata | Type validation; Null checks; Duplicate checks; Referential integrity; Business validation | KPI correctness; Aggregation validation; Reconciliation; Business acceptance |

Mô hình trách nhiệm (bảng trong bài, dựng lại; có thể gộp vai trò tùy quy mô, không bắt buộc mỗi vai trò là một team riêng):

| Thành phần | Trách nhiệm |
|---|---|
| Source owner | Chịu trách nhiệm về dữ liệu tại hệ thống nguồn |
| Data engineering | Xây dựng và vận hành ingestion, transformation |
| Data owner | Định nghĩa và cách sử dụng dữ liệu thuộc phạm vi quản lý |
| Data steward | Hỗ trợ chuẩn hóa thuật ngữ, quy tắc và chất lượng dữ liệu |
| Data consumer | Sử dụng dữ liệu theo hợp đồng và chính sách đã thống nhất |

- **Có nên materialize?**
  - Nên tạo bản vật lý khi cần: tăng hiệu năng truy vấn; tách quyền truy cập; lưu lịch sử/audit; xử lý lại độc lập; tái sử dụng phép biến đổi tốn kém; tách workload giữa các nhóm.
  - Không cần nếu phép biến đổi đơn giản có thể làm hiệu quả lúc truy vấn.
  - Quyết định theo workload, hiệu năng, bảo mật, khả năng khôi phục, chi phí vận hành.
- **Khi platform lớn, cân nhắc tách ranh giới theo**: data ownership; security & quyền truy cập; lifecycle & chính sách lưu trữ; quy trình triển khai & thay đổi; trách nhiệm vận hành; business domain.
- **Xử lý bản ghi lỗi** (vd. Order thiếu `CUSTOMER_ID`): từ chối / đưa vào quarantine / chấp nhận tạm thời để xử lý sau. Chọn theo mức nghiêm trọng, tính chất dữ liệu, yêu cầu nghiệp vụ; không phải lỗi nào cũng làm fail cả pipeline.
- **Bộ ba production**: Data Quality xác định dữ liệu có đạt yêu cầu; Reprocessing phục hồi kết quả khi logic/dữ liệu cần xử lý lại; Idempotency giúp retry không làm sai lệch kết quả.

**6. Best practices / nguyên tắc thiết kế**
- Bronze giữ nguyên giá trị nguồn (`STATUS='A'`), không diễn giải sớm thành `CUSTOMER_STATUS='ACTIVE'` / `CUSTOMER_TYPE='VIP'` (vì có thể chứa business logic hoặc quy tắc phân loại không có trong source) → khi quy tắc đổi vẫn xử lý lại được. Bổ sung technical metadata.
- Đặt retention của Bronze theo audit, khả năng khôi phục, chi phí, bảo mật.
- Quy tắc DQ ở Silver phải dựa trên nghiệp vụ và phân biệt theo loại giao dịch.
- Conformance phải nêu rõ mapping và cách xử lý xung đột.
- Ưu tiên một mô hình dùng chung (một khái niệm Customer) có quy tắc rõ ràng, thay vì nhiều phiên bản độc lập.
- Gold dataset phải có định nghĩa chỉ số, thời điểm chốt dữ liệu, quy tắc tính toán, đối tượng sử dụng. Nếu hai báo cáo tính `margin_ratio` khác nhau, Gold phải cung cấp định nghĩa thống nhất hoặc thể hiện rõ là đang dùng quy tắc nghiệp vụ khác nhau.
- Bốn nguyên tắc ranh giới enterprise:
  1. Không tạo ranh giới chỉ vì tên layer khác nhau — việc tách phải mang lợi ích rõ về quản trị, bảo mật, hiệu năng hoặc vận hành.
  2. Không đồng nhất layer với business domain — Silver có thể chứa nhiều domain, nhưng ownership và quyền quản trị từng domain phải rõ.
  3. Tránh tạo quá nhiều dataset trùng lặp.
  4. Quản lý thay đổi xuyên layer (kiểm soát tương thích, kiểm thử, triển khai), vì thay đổi schema/logic ở Bronze/Silver lan tới nhiều Gold Data Product.
- Mục tiêu thiết kế enterprise là ranh giới "đủ rõ" để platform phát triển mà không khó quản lý, không phải tạo nhiều thành phần nhất.
- Kiểm tra chất lượng ở mọi layer, không đợi tới Gold.
- Reprocessing phải thiết kế cùng quy tắc phụ thuộc giữa dataset, phạm vi dữ liệu cần tính lại và chính sách ghi đè. Cần xác định Bronze có lưu đủ phiên bản khi nguồn sửa dữ liệu lịch sử hay không.
- Kỹ thuật idempotency:
  - business key kết hợp MERGE/UPSERT;
  - batch ID để xác định phạm vi xử lý;
  - record hash để phát hiện thay đổi;
  - watermark/checkpoint cho incremental;
  - quy tắc cho bản ghi đến muộn hoặc bị cập nhật;
  - với CDC: chú ý thứ tự sự kiện, UPDATE/DELETE, khả năng xử lý lại cùng một sự kiện.
- Quản lý quyền truy cập, dữ liệu nhạy cảm, thời hạn lưu trữ và việc sử dụng đúng mục đích được phép.
- Thiết kế các năng lực vận hành/quản trị xuyên suốt vòng đời dữ liệu, không gắn riêng một layer.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Coi Medallion là ba folder; thiết kế chỉ dựa trên cách tổ chức storage.
- Đặt business logic/diễn giải vào Bronze; giữ mọi bản sao vô thời hạn, không có retention policy.
- Áp một quy tắc DQ chung cho mọi loại giao dịch (giao dịch điều chỉnh có thể hợp lệ với số lượng âm).
- Conformance chỉ bằng đổi tên cột.
- Tin rằng "Gold chỉ dành cho Power BI/báo cáo"; coi Gold chỉ là kết quả JOIN vài bảng.
- Mặc định mỗi layer là một bản sao đầy đủ (10 TB × 3 = 30 TB), lại thêm intermediate tables, snapshot, bản sao riêng cho từng team → chi phí lưu trữ & vận hành tăng đáng kể.
- Tạo ranh giới chỉ vì tên layer; đồng nhất layer với domain; có nhiều phiên bản Customer độc lập.
- Đợi tới Gold mới kiểm tra chất lượng; để mọi lỗi làm fail cả pipeline.
- Retry bằng INSERT thuần → `ORDER_ID 10001` bị trùng.
- Mặc định mọi dữ liệu Silver/Gold đều được chia sẻ cho toàn doanh nghiệp.
- Coi DQ/Reprocessing/Idempotency là việc bổ sung sau khi pipeline đã hoàn thành.
- Rủi ro production cần lường trước: pipeline lỗi giữa chừng; source gửi dữ liệu trùng; dữ liệu thiếu hoặc đến muộn; schema nguồn thay đổi; business logic phát hiện sai sau nhiều ngày; một dataset đầu ra lỗi trong khi các dataset khác vẫn hoạt động.

**8. Ví dụ minh họa**
- **Kịch bản công ty chứng khoán (§1)**: nguồn gồm Oracle Core, OMS, Tibero, CRM, hệ thống Risk, Market Data API. Bronze (Source Customer/Account/Order/Trade) → Silver (Customer, Account, Order, Trade, Position, Margin) → Gold (Customer 360, Daily Trading, Customer Position, Margin Risk, Daily P&L).
- **Bronze (§2)**: bản ghi Oracle `CUSTODYCD='001C123456'`, `FULLNAME='NGUYEN VAN A'`, `STATUS='A'` được giữ nguyên; không suy diễn `ACTIVE`/`VIP` tại đây.
- **Silver (§3)**:
  - trim `' 001C123456 '` → `'001C123456'`;
  - chuỗi `TRADE_DATE='2026-09-28'` → kiểu DATE;
  - dedup các bản ghi cùng `ORDER_ID`;
  - rule mẫu: `ORDER_ID NOT NULL`, `CUSTOMER_ID NOT NULL`, `TRADE_DATE VALID DATE`, `QUANTITY >= 0`, `PRICE > 0`;
  - `CUSTODYCD` (Oracle Core) / `CUSTOMER_CODE` (CRM) / `CLIENT_ID` (Risk) → `customer_id`.
- **Gold (§4)**: từ `Silver.Customer/Order/Trade/Position/MarketPrice` xây `Gold.Customer360, DailyTrading, CustomerPosition, MarginRisk, RealizedPnL, UnrealizedPnL, Revenue`. `Gold.MarginRisk` gồm: customer_id, account_id, equity, margin_loan, market_value, maintenance_ratio, margin_ratio, risk_level, as_of_time.
- **End-to-end (§7)**:
  - Bronze theo nguồn: `bronze.oracle.cust_master`, `bronze.oracle.odmast`, `bronze.oracle.tltrans`, `bronze.tibero.order`, `bronze.tibero.trade`, `bronze.market.price`, `bronze.risk.margin`.
  - Silver theo mô hình dùng chung: `silver.customer, account, order, trade, position, cash, margin, market_price`. `silver.customer` gồm customer_id, customer_name, customer_status, customer_type, branch_id, created_date, updated_date; mapping giữa các nguồn xử lý tại đây để downstream không phải tự xây lại logic chuẩn hóa Customer.
  - Gold theo nhu cầu nghiệp vụ: `gold.customer_360, daily_trading, customer_position, margin_risk, daily_pnl, revenue, aum`. Dashboard hiển thị tình hình rủi ro, ứng dụng nghiệp vụ dùng chỉ số đã tính, AI hỗ trợ phân tích xu hướng.
  - Phân tích "Customer X": equity giảm, margin utilization tăng, portfolio concentration tăng, risk indicators xấu đi → cảnh báo hoặc hỗ trợ đánh giá rủi ro. Kết luận chỉ đáng tin khi định nghĩa dữ liệu, thời điểm chốt số liệu và phép tính được kiểm soát.
- **Storage (§5)**: Bronze 10 TB + Silver 10 TB + Gold 10 TB = 30 TB — chỉ minh họa, không phải yêu cầu của Medallion.
- **Reprocessing (§8.2)**: lỗi transformation ảnh hưởng dữ liệu ngày 20/09/2026 → xử lý lại partition Bronze 2026-09-20 → Silver → Gold, không cần trích xuất lại toàn bộ từ source.
- **Idempotency (§8.3)**: job đã nạp `ORDER_ID = 10001`, thất bại, retry chỉ INSERT → hai dòng 10001.
- **DQ (§8.1)**: Order thiếu `CUSTOMER_ID` → cần quy tắc rõ (từ chối / quarantine / chấp nhận tạm).
- **Lineage (§9)**: dữ liệu Customer sai → lineage chỉ ra Gold.Customer360, Gold.CustomerRisk, Customer Dashboard, Risk Application có thể bị ảnh hưởng.

**9. Công nghệ/công cụ được nhắc tới**
- **Nguồn**: Oracle Core (CUSTODYCD, cust_master, odmast, tltrans), OMS, Tibero (order, trade), CRM, hệ thống Risk, Market Data API.
- **Dạng dữ liệu ở Bronze**: raw tables, JSON (API), CSV, Parquet, event, CDC, snapshot.
- **Consumer**: Power BI (dashboard — tác giả nhấn mạnh Gold không chỉ phục vụ Power BI), Risk App, AI, Data API.
- **Kỹ thuật**: MERGE/UPSERT, batch ID, record hash, watermark/checkpoint; CDC (thứ tự sự kiện, UPDATE/DELETE).
- **Bối cảnh từ bài trước**: Data Lake, Lakehouse, Data Warehouse. Bài không gắn Medallion với vendor/sản phẩm cụ thể.

**10. Checklist / câu hỏi thiết kế**
- **5 câu hỏi thiết kế Medallion**:
  1. Dữ liệu gốc được bảo toàn và truy vết thế nào?
  2. Quy tắc làm sạch/chuẩn hóa được quản lý ở đâu?
  3. Dataset nào cần dùng chung giữa các team?
  4. Dữ liệu được kiểm tra, xử lý lại, vận hành ổn định ra sao?
  5. Data Product có đáp ứng đúng định nghĩa nghiệp vụ và yêu cầu quản trị không?
- **7 câu hỏi governance**: dataset thuộc team nào; ai chịu trách nhiệm khi dữ liệu sai; tần suất cập nhật; dataset nào chứa dữ liệu nhạy cảm; ai được đọc/thay đổi; chỉ số tính từ nguồn nào; schema đổi thì báo cáo/ứng dụng nào bị ảnh hưởng.
- **Danh sách khác**: 6 tình huống production cần thiết kế trước (mục 7), 6 lý do materialize, 6 tiêu chí tách ranh giới, 4 nguyên tắc ranh giới (mục 5–6), kiểm tra DQ theo layer (bảng mục 5).

**11. Kết luận & key takeaways**
- Medallion là cách tổ chức trách nhiệm và quá trình hoàn thiện dữ liệu từ nguồn đến sản phẩm nghiệp vụ, không phải ba folder.
- Bronze = bảo toàn & truy vết; Silver = nền dữ liệu dùng chung giữa các domain; Gold = Data Product (Customer 360, Trading, Position, Margin Risk, P&L, Revenue).
- Layer là ranh giới logic; chỉ tách hoặc materialize vật lý khi có lý do kỹ thuật, vận hành, nghiệp vụ.
- DQ, Reprocessing, Idempotency, Governance, Lineage là năng lực production xuyên suốt, phải thiết kế từ đầu.
- Lợi ích: pipeline đáng tin cậy, giảm trùng lặp logic, dữ liệu nhất quán cho BI, Analytics, AI và ứng dụng nghiệp vụ.
- Trích: *"Chỉ materialize dữ liệu khi có lý do kỹ thuật, vận hành hoặc nghiệp vụ rõ ràng."*
- Trích: *"Hãy thiết kế Medallion dựa trên chất lượng dữ liệu, business meaning, ownership, security và workload — không chỉ dựa trên cách tổ chức storage."*

**12. Liên kết với các bài khác**
- **Nhìn lại**: "các bài trước" về kiến trúc tổng thể Modern Data Platform, Data Ingestion và mô hình lưu trữ Data Lake/Lakehouse/Data Warehouse. [Ghi chú] Bài không ghi số bài; theo thứ tự series, nhiều khả năng là Bài 1–3.
- **Nhìn tới**: Bài 4 không nêu tên bài kế tiếp. Tuy vậy:
  - Bài 5 mở đầu bằng "Ở bài trước… Medallion Architecture" và lấy Bronze/Silver/Gold làm nền cho orchestration.
  - Idempotency/reprocessing (§8.2–8.3) được Bài 5 §4 đào sâu thành retry, checkpoint, backfill.
  - DQ theo layer (§8.1) được Bài 6 §4 phát triển; mô hình vai trò (§9) được Bài 6 §9 mở rộng.
  - Lưu ý về CDC (thứ tự sự kiện, UPDATE/DELETE) chỉ được nêu ngắn.


---

## Bài 5: Data Pipeline Orchestration & Metadata-Driven Architecture
*Subtitle: "From Running Pipelines to Building a Scalable Data Platform" · Ngày đăng: 2026-10-05 · URL: https://duongpk9x.substack.com/p/data-platform-architect-bai-5 · Không có ảnh; 3 bảng dạng text đã dựng lại.*

Mục lục (H2): 1. Từ Medallion Architecture đến Data Pipeline Orchestration | 2. Task, Workflow và Dependency Graph | 3. Scheduling, Trigger và Resource-aware Execution | 4. Reliability: Retry, Idempotency, Checkpoint và Backfill | 5. Từ Pipeline-centric sang Metadata-driven Architecture | 6. Metadata Registry và Data Control Plane | 7. Quản lý Dependency, Parallelism, SLA và Data Quality | 8. Metadata as Code, CI/CD và Validation | 9. Case Study: Metadata-driven Securities Data Platform | 10. Lựa chọn công cụ và lộ trình phát triển Data Platform (phần "Kết luận" là H3 nằm trong mục 10)

**1. Bối cảnh & vấn đề mở đầu**
- Sơ đồ `Source Systems → Ingestion → Bronze → Silver → Gold → Data Consumers` của Bài 4 mới mô tả cách dữ liệu di chuyển và được tổ chức, chưa giải bài toán vận hành.
- Ba câu hỏi vận hành:
  - Silver cần dữ liệu từ ba bảng Bronze: làm sao bảo đảm cả ba đã được cập nhật trước khi xử lý?
  - Một job lỗi giữa chừng: tiếp tục từ bước lỗi hay chạy lại toàn bộ pipeline?
  - Một bảng Gold phục vụ nhiều báo cáo và ứng dụng: khi nguồn thay đổi, task nào cần chạy lại?
- Khi số pipeline tăng, thách thức không còn là "chạy được một job" mà là quản lý hàng trăm pipeline nhất quán mà không để độ phức tạp vận hành tăng quá nhanh.

**2. Luận điểm cốt lõi**
Orchestration điều phối thời điểm, thứ tự, dependency, lỗi và trạng thái — nhưng chỉ là một thành phần của platform. Ở quy mô lớn phải chuyển từ pipeline-centric sang Metadata-driven Architecture: code định nghĩa *cách* xử lý, metadata mô tả *đối tượng* cần xử lý và policy, orchestrator điều phối, còn Data Control Plane kết nối metadata, trạng thái, policy và vận hành. Kiến trúc nên tiến hóa dần theo quy mô thực tế thay vì xây "đầy đủ" ngay từ ngày đầu.

**3. Khái niệm chính**
- **Data Pipeline Orchestration**: khả năng điều phối việc thực thi các tác vụ dữ liệu, gồm quản lý dependency, kiểm soát lịch chạy, xử lý lỗi và theo dõi trạng thái toàn workflow. Orchestrator không nhất thiết trực tiếp làm phần xử lý.
- **Data Processing / Data Pipeline / Orchestration**:
  - Data Processing: đọc, làm sạch, JOIN, tổng hợp, ghi dữ liệu.
  - Data Pipeline: chuỗi các tác vụ xử lý có quan hệ với nhau.
  - Orchestration: điều khiển thời điểm, thứ tự, dependency và cách xử lý khi task thành công/thất bại.
- **Task**: đơn vị công việc thực thi và theo dõi trạng thái được; nên có trách nhiệm rõ, input/output xác định để dễ kiểm thử, theo dõi lỗi, chạy lại.
- **Workflow**: tập task được kết nối để hoàn thành một quy trình, tạo ra một kết quả nghiệp vụ hoặc kỹ thuật.
- **DAG (Directed Acyclic Graph)**: đồ thị có hướng, không chu trình, mô tả dependency. DAG **không** có nghĩa là mọi task chạy tuần tự: task độc lập chạy song song, task phụ thuộc chỉ chạy khi input đã sẵn sàng.
- **Data Dependency Graph**: khi nhiều pipeline chia sẻ dữ liệu, hệ thống thành một graph lớn nối nguồn, data model, data product (không còn là chuỗi A → B → C).
- **DAG vs Data Lineage**: DAG mô tả quan hệ thực thi; Lineage truy vết nguồn gốc và quá trình biến đổi dữ liệu. Hai thứ bổ trợ, không thay thế nhau.
- **Run time vs data interval**: thời điểm chạy khác với khoảng dữ liệu được xử lý.
- **Watermark / Checkpoint**: watermark xác định phạm vi dữ liệu incremental kế tiếp; checkpoint lưu tiến độ xử lý. Với CDC/streaming, checkpoint còn gắn với offset, state và cơ chế khôi phục riêng của engine.
- **Kiểu kích hoạt**: schedule-driven, event-driven, on-demand execution.
- **Resource-aware scheduling**: phối hợp concurrency limit, queue, resource pool (slot) và priority.
- **Retry / Timeout**: retry thử lại khi gặp lỗi tạm thời; timeout giới hạn thời gian thực thi để task không chạy vô thời hạn.
- **Idempotency**: chạy lại một công việc mà không tạo tác động nghiệp vụ ngoài ý muốn (vd. không trùng bản ghi).
- **Replay / Backfill**: replay phát lại dữ liệu/sự kiện để xử lý lại; backfill chạy pipeline cho khoảng dữ liệu lịch sử cần bổ sung hoặc tính lại.
- **Configuration drift**: cấu hình lệch nhau khi phải sửa tay nhiều DAG mà bỏ sót.
- **Metadata-driven Architecture**: metadata mô tả đối tượng dữ liệu, cách xử lý, dependency và policy; một framework dùng metadata đó để xây dựng hoặc điều phối việc thực thi.
- **Execution Plan**: kế hoạch thực thi mà framework tạo ra sau khi parse, validate metadata và dựng dependency graph.
- **Metadata Registry**: nơi quản lý các nhóm metadata. Không bắt buộc gom vào một database; có thể là catalog, registry, DB quản lý cấu hình hoặc hệ thống chuyên dụng.
- **Data Control Plane vs Data Plane**: Control Plane quản lý metadata, policy, dependency, trạng thái và quyết định vận hành; Data Plane là nơi dữ liệu được lưu trữ và xử lý.
- **Dependency-aware execution, SLA & Priority, điều kiện publish**: dependency gắn với trạng thái dữ liệu, thời hạn và kiểm tra chất lượng.
- **Metadata as Code**: quản lý metadata trong Git, đi qua review, validation và CI/CD như code.
- **Circular dependency**: `A → B → C → A` — không có thứ tự thực thi hợp lệ.

**4. Kiến trúc, pattern & quy trình**
- **Pipeline giao dịch mẫu**: `Extract Source Data → Load Bronze → Validate Bronze → Transform Silver → Build Gold Data Product → Validate Gold → Publish to Consumers`. Mỗi bước có thể là Python, SQL, dbt, Spark hoặc dịch vụ xử lý dữ liệu trên cloud.
- **Workflow mẫu**: `Load Orders → Clean Orders → Join Payments → Calculate Revenue → Publish Gold Dataset`.
- **DAG song song**: `(Bronze Customer → Silver Customer) ∥ (Bronze Order → Silver Order) → Gold Customer Order → Gold Order Summary`.
- **Data Dependency Graph**:
  - `Silver Customer → Gold Customer → Customer Portfolio`;
  - `Silver Security → Gold Market`;
  - `Silver Order → Gold Order → Gold Position`;
  - cả ba nhánh hội tụ về `Gold Risk`.
  - Gold Order lỗi → downstream chưa đủ điều kiện chạy; nhánh độc lập (Gold Market) vẫn tiếp tục.
- **Event-driven**: `New Data Arrives → Validate Data Availability → Trigger Processing → Publish Dataset`.
- **Retry**: `Task Failed → Retry Allowed? → Yes: Retry | No: Mark Failed → Alert`.
- **Incremental**: `Last Successful Watermark → Read New Changes → Write Target → Validate Output → Commit New Watermark`.
- **Metadata-driven**: `Metadata Definitions → Metadata Parser → Configuration Validation → Dependency Graph → Execution Plan → Orchestrator → Processing Tasks`.
- **Mô hình metadata minh họa**:
  - `data_model`: model_id, model_name, layer, domain, owner, source, target, load_type, enabled.
  - `data_model_dependency`: model_name, depends_on, dependency_type.
  - `pipeline_run`: run_id, model_name, batch_id, start_time, end_time, status, watermark_start, watermark_end, rows_read, rows_written, retry_count.
  - `data_quality_rule`: model_name, rule_name, rule_type, threshold, severity, enabled.
  - Triển khai thực tế còn cần khóa, kiểu dữ liệu, quan hệ, lịch sử thay đổi và trạng thái theo từng lần chạy.
- **Control Plane / Data Plane**: `DATA PLANE = Bronze/Silver/Gold Storage + Processing Engines` ↔ `CONTROL PLANE = Metadata Registry, Dependency Graph, Orchestration, Quality Policies, Observability, Governance`. Đây là mô hình logic; các chức năng có thể phân bố trên nhiều dịch vụ/công cụ.
- **Điều kiện publish**: `Upstream Completed → Data Freshness Check → Completeness Check → Business Rule Validation → Publish Gold Dataset`. Nếu một kiểm tra quan trọng fail: chặn publish, đánh dấu dataset không đạt chất lượng, hoặc chuyển sang quy trình xử lý ngoại lệ.
- **CI/CD**: `Developer Change → Git → Pull Request → Validation & Tests → Deploy to Staging → Integration Tests → Deploy to Production → Metadata Registry → Orchestrator`.
- **Repo tham khảo**: `data-platform/{metadata/{sources, models, dependencies, policies}, sql/, src/, dags/, tests/, deployment/}`.
- **Kiến trúc tổng thể (case study)**: Data Plane `Source Systems → Ingestion → Bronze → Silver → Gold` ∥ Control Plane `Metadata Registry → Dependency Graph → Orchestration → Scheduling/Retry → State/SLA/Policy` → cùng hội tụ vào `Quality & Observability → Data Consumers`.
- **Công thức kết luận**: `Reusable Processing Framework + Metadata + Dependency Graph + Orchestration + State & Recovery + Quality & Observability + Governance + CI/CD`.

**5. Framework ra quyết định & so sánh**

Các nhóm metadata (bảng trong bài, dựng lại):

| Nhóm | Ví dụ |
|---|---|
| Technical Metadata | Source system, database, schema, table, column, data type, partition |
| Dependency Metadata | Model, upstream, downstream, dependency type |
| Operational Metadata | Schedule, retry, timeout, priority, concurrency |
| Business Metadata | Business owner, data domain, business definition, classification |
| Processing Metadata | Last successful run, watermark, rows read, rows written, duration, status |
| Quality Metadata | Rule, threshold, severity, kết quả kiểm tra chất lượng |
| Governance Metadata | Access policy, ownership, lineage, chính sách lưu trữ |

Công cụ (bảng trong bài, dựng lại; chỉ mô tả trọng tâm sử dụng phổ biến, không phải danh sách tính năng đầy đủ):

| Công cụ | Vai trò chính |
|---|---|
| Apache Airflow | Điều phối workflow tổng quát thông qua DAG |
| Dagster | Quản lý data assets, dependency và observability |
| Prefect | Điều phối workflow theo hướng Python |
| Databricks Workflows | Điều phối workload trong hệ sinh thái Databricks |
| Microsoft Fabric Data Factory/Pipelines | Điều phối tác vụ tích hợp và xử lý dữ liệu trong Fabric |
| dbt | Quản lý SQL transformation, dependency giữa các model, kiểm thử dữ liệu |

→ dbt tập trung vào transformation; Airflow có thể điều phối cả ingestion, dbt, Spark và công việc bên ngoài. Chúng bổ trợ nhau, không cần chọn duy nhất một công cụ.

Pipeline-centric vs Metadata-driven (bảng tổng hợp từ §5, §8, §10):

| | Pipeline-centric | Metadata-driven |
|---|---|---|
| Phù hợp | Platform nhỏ; đơn giản, hiệu quả | Hàng trăm nguồn, hàng nghìn task, nhiều data product phụ thuộc nhau |
| Cấu hình | Hard-code trong từng DAG (`bronze_customer_dag`, `bronze_order_dag`…) | Khai báo trong metadata; framework tạo execution plan |
| Rủi ro | Sửa nhiều nơi, configuration drift | Metadata sai ảnh hưởng toàn hệ thống → cần Metadata as Code, validation |
| Code | Lặp lại giữa các pipeline | Chuẩn hóa phần có quy luật chung; logic phức tạp vẫn viết bằng code/SQL |

Ranh giới trách nhiệm: **Code** = cách xử lý · **Metadata** = đối tượng cần xử lý + policy liên quan · **Orchestrator** = thời điểm, thứ tự, trạng thái thực thi.

Phân loại workload ([Ghi chú] gộp hai ví dụ minh họa ở §3 và §7; mọi con số đều chỉ là minh họa):

| Nhóm | Workload ví dụ (§7) | Slot minh họa (§3) |
|---|---|---|
| Critical | Risk, Trading | 10 |
| Normal | Customer Analytics, Operational Reporting | 30 |
| Heavy Batch / Heavy ETL | Historical Reprocessing, Large Aggregations | 5 |

- **SLA & Priority** (minh họa): `gold_risk` — priority critical, SLA 5 phút; `gold_daily_report` — priority normal, SLA 60 phút. SLA thực tế phải theo nhu cầu nghiệp vụ.
- **Có nên retry?** Lỗi kết nối tạm thời → retry; sai schema hoặc SQL không hợp lệ → phải sửa trước.
- **Kích hoạt**: schedule-driven, event-driven, on-demand — một platform có thể kết hợp cả ba.
- **Replay vs Backfill**: phát lại dữ liệu/sự kiện vs chạy lại pipeline cho khoảng thời gian lịch sử.

**6. Best practices / nguyên tắc thiết kế**
- Task có trách nhiệm rõ, input/output xác định.
- Hiểu toàn bộ quan hệ phụ thuộc giữa dữ liệu, tác vụ, data product — không chỉ quan tâm số lượng DAG.
- Xác định đúng data interval, watermark và trạng thái lần chạy trước để không bỏ sót dữ liệu.
- Với event-driven: cần cơ chế xác nhận dữ liệu hoàn tất (file, dữ liệu từ hệ thống bên ngoài) trước khi xử lý.
- Giới hạn concurrency/queue/resource pool theo năng lực database, cluster, memory, CPU và SLA; ưu tiên pipeline quan trọng (báo cáo rủi ro cần cập nhật nhanh > job tổng hợp lịch sử).
- Retry có chọn lọc, kèm timeout.
- Kỹ thuật idempotency:
  - MERGE/UPSERT theo business key;
  - ghi vào staging rồi hợp nhất vào bảng đích;
  - nạp lại một partition trong phạm vi dữ liệu xác định;
  - theo dõi batch ID hoặc processing ID;
  - chỉ cập nhật watermark sau khi dữ liệu được ghi và xác nhận thành công.
- Commit watermark nhất quán với việc ghi dữ liệu.
- Backfill: quản lý phạm vi thời gian, tránh ghi đè ngoài phạm vi, bảo đảm model phụ thuộc được cập nhật.
- Thiết kế retry/idempotency/checkpoint/backfill ngay từ đầu, không đợi gặp sự cố.
- Dùng metadata-driven để chuẩn hóa và tự động hóa phần có quy luật chung; giữ code cho biến đổi phức tạp.
- Dùng metadata cho orchestration, DQ, lineage, observability, SLA management, governance, documentation — không chỉ để sinh DAG.
- Dependency-aware: lỗi cục bộ không làm dừng mọi pipeline không liên quan.
- Tối ưu thời gian hoàn thành mà không gây quá tải, thay vì chạy càng nhiều task càng tốt.
- SLA cần đi kèm monitoring, phân bổ tài nguyên, cơ chế xử lý khi workload tăng hoặc upstream chậm.
- Gắn điều kiện publish với freshness, completeness và business rules.
- Metadata as Code: không sửa trực tiếp metadata production; thay đổi đi qua review và validation; framework kiểm tra graph trước khi deploy và từ chối cấu hình không hợp lệ.
- Lưu lịch sử phiên bản metadata, có phương án phục hồi. Thay đổi có ảnh hưởng đến dữ liệu phải kèm chiến lược khôi phục, đối soát hoặc xử lý lại.
- Chọn công cụ bắt đầu từ yêu cầu kiến trúc; các công cụ có thể bổ trợ nhau.
- Để kiến trúc tiến hóa cùng quy mô, độ phức tạp và nhu cầu thực tế.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Nghĩ sơ đồ Medallion đã giải bài toán vận hành; coi orchestrator là toàn bộ Data Platform.
- Hiểu DAG là chạy tuần tự; chỉ đếm số DAG; nhầm DAG với lineage.
- Nhầm thời điểm chạy với khoảng dữ liệu → bỏ sót dữ liệu incremental.
- Coi sự kiện xuất hiện là dữ liệu đã sẵn sàng.
- Cho 200 task độc lập chạy đồng thời → quá tải database nguồn hoặc cluster.
- Retry mọi lỗi; tin rằng retry tự bảo đảm idempotency.
- Cập nhật watermark quá sớm → bỏ qua bản ghi chưa được ghi thành công.
- Coi backfill chỉ là chạy lại một task (ghi đè ngoài phạm vi, quên cập nhật downstream).
- Chỉ bổ sung cơ chế reliability sau khi đã gặp sự cố.
- Một DAG riêng cho mỗi bảng khi quy mô lớn; hard-code retry trong 200 DAG → configuration drift.
- Hiểu metadata-driven là loại bỏ code hoặc biến mọi thứ thành cấu hình; dùng metadata chỉ để generate DAG.
- Chỉ dựa vào lịch chạy cố định cho hàng trăm model.
- Tin rằng khai báo SLA là đã đáp ứng SLA.
- Publish chỉ vì pipeline hoàn thành về kỹ thuật (`gold_risk` tạo thành công nhưng market data chưa cập nhật hoặc thiếu giao dịch).
- Sửa metadata production tùy ý; để lọt circular dependency.
- Tin rằng rollback metadata/code sẽ hoàn tác dữ liệu đã ghi sai.
- Xây Stage 5 (Data Control Plane) ngay từ ngày đầu; framework quá phức tạp trở thành gánh nặng bảo trì.
- Chọn công cụ trước khi rõ yêu cầu kiến trúc.

**8. Ví dụ minh họa**
- **Case study Metadata-driven Securities Data Platform (§9)** — phục vụ hệ thống giao dịch, báo cáo và phân tích rủi ro. Nguồn: Oracle, Tibero, MariaDB, MongoDB, External APIs. Mục tiêu: đưa vào Bronze, chuẩn hóa ở Silver, tạo data product ở Gold.
  - **Bước 1 – khai báo nguồn** (bảng trong bài, dựng lại; tần suất chỉ là ví dụ, phải phù hợp năng lực nguồn và nghiệp vụ):

    | Source table | Load type | Frequency |
    |---|---|---|
    | CUSTOMER | Incremental | 5 phút |
    | ACCOUNT | Incremental | 5 phút |
    | SECURITY | Incremental | 5 phút |
    | ORDER | Incremental | 1 phút |
    | TRANSACTION | Incremental | 1 phút |

    Luồng: `Source Metadata → Ingestion Framework → Bronze Tasks → Bronze Datasets` (thay vì viết logic ingestion riêng cho từng bảng).
  - **Bước 2 – Silver & Gold models**:
    - Silver: `bronze_customer → silver_customer`; `bronze_order → silver_order`; `bronze_security → silver_security`.
    - Gold: `silver_customer → gold_customer → gold_portfolio`; `silver_order → gold_order → gold_position → gold_portfolio → gold_risk`.
    - Metadata khai báo nguồn, đích, kiểu xử lý, dependency → framework dựng graph thực thi.
  - **Bước 3 – `gold_position` lỗi**, platform phải:
    1. ghi nhận trạng thái và thông tin lỗi của lần chạy;
    2. retry theo policy nếu lỗi có thể phục hồi;
    3. không cho các bước downstream dùng dữ liệu chưa đạt điều kiện;
    4. phát cảnh báo nếu không thể hoàn thành trong SLA;
    5. cho phép chạy lại phạm vi dữ liệu phù hợp sau khi khắc phục.
    - Khi `gold_position` xong, model phụ thuộc tiếp tục nếu input sẵn sàng và đạt kiểm tra.
  - **Bước 4 – metadata `gold_risk`**: domain risk, owner risk_data_team, priority critical, sla_minutes 5, depends_on gold_position & gold_market, quality_rules data_freshness & business_key_unique. Cùng một định nghĩa hỗ trợ: theo dõi dependency; xác định owner; theo dõi thời gian hoàn thành & SLA; áp dụng kiểm tra chất lượng; truy vết nguồn; xác định model bị ảnh hưởng khi nguồn thay đổi.
- **YAML (§5)**:
  - `gold_order`: source silver/`silver_order` → target gold/`gold_order`; load_type incremental; watermark_column `updated_at`; depends_on `silver_order`; retry max_attempts 3.
  - `gold_order_summary`: source gold/`gold_order` → target gold/`gold_order_summary`; load_type incremental; depends_on `gold_order`.
- **Metadata `gold_risk` (§6)**: như Bước 4, quality_rules có thêm `required_fields`.
- **Dependency chain (§7)**: `silver_order → gold_order → gold_position → gold_portfolio → gold_risk`. `gold_customer`, `gold_security`, `gold_account` độc lập → chạy song song, nhưng phải giới hạn nếu dùng chung database nguồn hoặc Spark cluster.
- **Lịch**: báo cáo doanh thu chạy 02:00 hằng ngày; chạy 02:00 ngày 21/10 là xử lý dữ liệu 20/10. Chu kỳ: mỗi 5 phút, mỗi giờ, mỗi ngày, mỗi tuần, cuối tháng.
- **Idempotency**: pipeline nạp giao dịch ngày 20/10 lỗi sau khi đã ghi một phần → chạy lại không được tạo bản ghi trùng.
- **Backfill**: 2026-10-14 Success, 10-15 Missing Data, 10-16 và 10-17 Success → sau khi khắc phục, xử lý lại 15/10 và xác định các dataset downstream cần cập nhật.
- **Quy mô**: 200 task độc lập chạy cùng lúc → quá tải; 200 DAG khai báo retry cố định → configuration drift khi chính sách thay đổi.
- **Circular dependency**: `A → B → C → A`.

**9. Công nghệ/công cụ được nhắc tới**
- **Orchestration**: Apache Airflow, Dagster, Prefect, Databricks Workflows, Microsoft Fabric Data Factory/Pipelines (vai trò như bảng mục 5).
- **Transformation/processing**: dbt, Python, SQL, Spark (Spark cluster là tài nguyên cần giới hạn song song), dịch vụ xử lý dữ liệu trên cloud.
- **Nguồn (case study)**: Oracle, Tibero, MariaDB, MongoDB, External APIs.
- **Quản lý thay đổi**: Git, Pull Request, CI/CD, môi trường staging.
- **Lưu metadata**: catalog, registry, cơ sở dữ liệu quản lý cấu hình, hệ thống chuyên dụng.
- **CDC/streaming**: checkpoint gắn với offset và cơ chế khôi phục của engine.

**10. Checklist / câu hỏi thiết kế**
- **Validation trước deploy (8 mục)**: source & target tồn tại; metadata đủ trường bắt buộc; dependency trỏ tới model hợp lệ; không có model khai báo trùng; không có circular dependency; schema & kiểu dữ liệu hợp lệ; SQL & logic xử lý qua kiểm thử; data quality rules cấu hình đúng.
- **Câu hỏi chọn công cụ (7)**: dependency graph có phức tạp không; chạy theo lịch, sự kiện hay cả hai; workload chủ yếu là SQL, Python, Spark hay streaming; cần quản lý bao nhiêu nguồn & data model; SLA, retry, backfill, resource control cần ở mức nào; đội ngũ vận hành ổn định được nền tảng nào; chi phí hạ tầng & vận hành ra sao.
- **Lộ trình tiến hóa 5 stage**:
  1. *Individual Pipelines* — pipeline riêng cho các workload ban đầu; tập trung tính đúng đắn, khả năng vận hành, kiểm thử.
  2. *Reusable Framework* — chuẩn hóa kết nối, logging, retry, kiểm tra dữ liệu, cách ghi đích.
  3. *Metadata-driven Configuration* — đưa cấu hình có quy luật chung (source, target, load type, watermark) ra khỏi code.
  4. *Automated Dependency Graph* — tự động xây & kiểm tra graph, giảm khai báo thủ công pipeline cùng pattern.
  5. *Data Control Plane* — kết nối metadata với orchestration, state management, quality policies, observability, SLA, governance. Không xây Stage 5 từ ngày đầu nếu quy mô chưa cần.
- **Khác**: quy trình phục hồi 5 bước (Bước 3 case study) và 5 kỹ thuật idempotency (mục 6).

**11. Kết luận & key takeaways**
- Orchestration giải bài toán điều phối tác vụ dữ liệu; Metadata-driven mở rộng cách tiếp cận đó để quản lý số lượng lớn pipeline nhất quán và có khả năng mở rộng.
- Platform nhỏ: vài script SQL/Python + scheduler có thể đủ. Hàng trăm nguồn, hàng nghìn task, nhiều data product phụ thuộc → cần kết hợp framework + metadata + graph + orchestration + state & recovery + quality & observability + governance + CI/CD.
- Phân vai: Code (cách xử lý), Metadata (đối tượng & policy), Dependency Graph (quan hệ task/model), Orchestrator (điều phối), Control Plane (kết nối metadata, trạng thái, policy, vận hành), Data Plane (lưu trữ & xử lý thực tế).
- Trong platform trưởng thành, dependency gắn với trạng thái dữ liệu, SLA và điều kiện chất lượng, không chỉ là quan hệ giữa task.
- Platform trưởng thành không nhất thiết có nhiều DAG, nhiều công cụ hay mức tự động hóa cao nhất; quan trọng là quản lý phức tạp có kiểm soát, phục hồi khi lỗi, cung cấp dữ liệu đáng tin cậy.
- Trích: *"Retry không tự động bảo đảm idempotency."*
- Trích: *"…từ tư duy xây từng pipeline sang tư duy xây một nền tảng có khả năng tạo, điều phối và quản trị nhiều pipeline."*

**12. Liên kết với các bài khác**
- Mở đầu tiếp nối trực tiếp Bài 4 ("Ở bài trước… Medallion Architecture"). Dùng lại Bronze/Silver/Gold; idempotency & reprocessing (Bài 4 §8) được đào sâu thành retry/checkpoint/backfill; lineage & governance (Bài 4 §9) xuất hiện lại trong Governance Metadata và Control Plane.
- Watermark, sự kiện CDC, offset liên hệ các bài ingestion trước (incremental/CDC/streaming).
- Cuối bài hứa hẹn bài tiếp theo: "Data Quality & Observability – Làm thế nào để biết dữ liệu không chỉ được xử lý thành công mà còn đầy đủ, chính xác, nhất quán và đáng tin cậy?" [Ghi chú] Bài 6 thực tế mang tên "Data Quality & Data Contract" và tách Observability thành chủ đề riêng.
- Điều kiện publish, Quality Metadata và bảng `data_quality_rule` là tiền đề cho Quality Gate và Rule Management của Bài 6.


---

## Bài 6: Data Quality & Data Contract – Xây dựng nền tảng dữ liệu đáng tin cậy
*Subtitle: "From Data Validation to Data Trust: Thiết kế chất lượng dữ liệu và hợp đồng dữ liệu trong Modern Data Platform." · Ngày đăng: 2026-10-06 · URL: https://duongpk9x.substack.com/p/modern-data-platform-bai-6 · 3 ảnh (đều là bảng: bai06_01–03), nội dung đã đưa vào mục 5.*

Mục lục (H2): 1. Vì sao Data Platform cần Data Quality? | 2. Data Quality là gì? Xác định chất lượng dữ liệu theo góc nhìn kiến trúc | 3. Thiết kế Data Quality Rules: Từ yêu cầu nghiệp vụ đến quy tắc kiểm soát | 4. Data Quality theo Medallion Architecture | 5. Data Contract: Hợp đồng giữa hệ thống tạo và sử dụng dữ liệu | 6. Schema Evolution và quản lý thay đổi Data Contract | 7. Data Quality Gates: Khi nào dữ liệu được phép đi tiếp? | 8. Data Quality trong CI/CD và Data Testing | 9. Data Quality Ownership, Metadata và Governance | 10. Thiết kế kiến trúc Data Quality & Data Contract cho Enterprise Data Platform | Kết luận | Phân biệt với Data Observability | Series tiếp theo

**1. Bối cảnh & vấn đề mở đầu**
- Sau các bài về ingestion (Batch, Incremental, CDC, Streaming), Medallion và điều phối pipeline, còn một câu hỏi chưa được giải: làm sao biết dữ liệu sau xử lý thực sự chính xác và đủ tin cậy để sử dụng?
- Các tình huống: pipeline chạy thành công nhưng dữ liệu đầu ra sai; bảng cập nhật đầy đủ nhưng chứa bản ghi trùng; báo cáo tạo đúng giờ nhưng doanh thu thiếu dữ liệu từ một nguồn quan trọng.
- Ví dụ: hệ thống bán hàng ghi nhận 10.000 giao dịch/ngày; ELT chạy thành công vào Data Warehouse; lỗi chuyển đổi làm 500 giao dịch bị nhân đôi → tổng doanh thu cao hơn thực tế. Về kỹ thuật pipeline đã hoàn thành, về nghiệp vụ Data Platform đã thất bại.

**2. Luận điểm cốt lõi**
Data Quality phải là **năng lực cốt lõi** của platform, không phải bước kiểm tra bổ sung trong từng pipeline. DQ xác định dữ liệu có đạt tiêu chí hay không; Data Contract xác định các hệ thống đã thống nhất gì về dữ liệu; Quality Gates và Data Testing đưa các nguyên tắc đó vào quy trình xử lý và phát triển. Mục tiêu của kiến trúc sư là một cơ chế quản trị tái sử dụng được, có trách nhiệm rõ ràng, tích hợp xuyên suốt platform — không phải viết thật nhiều câu SQL kiểm tra.

**3. Khái niệm chính**
- **Data Quality**: tập hợp nguyên tắc, quy tắc và cơ chế kiểm soát bảo đảm dữ liệu đáp ứng yêu cầu sử dụng của nghiệp vụ và hệ thống tiêu thụ. Không chỉ là "không NULL, không lỗi định dạng": dữ liệu hợp lệ về kỹ thuật vẫn có thể sai về nghiệp vụ.
- **Quality dimensions**: 7 chiều (Accuracy, Completeness, Consistency, Validity, Uniqueness, Referential Integrity, Timeliness — xem bảng ảnh 1). Các chiều có thể chồng lấn khái niệm, vd. kiểm tra khóa ngoại liên quan cả tính hợp lệ lẫn toàn vẹn tham chiếu.
- **Data Quality Rule**: thành phần có vòng đời (không phải SQL rải rác trong pipeline), tối thiểu 8 thuộc tính: Rule ID, Business Meaning, Scope, Evaluation Logic, Threshold, Severity, Failure Action, Owner.
- **Data Contract**: thỏa thuận rõ ràng giữa **producer** (bên cung cấp) và **consumer** (bên sử dụng) về việc cung cấp gì, theo cấu trúc nào, với mức chất lượng nào. Hợp đồng phải kiểm tra và thực thi được trong phát triển, triển khai, vận hành — không chỉ là một file JSON mô tả schema.
- **Schema Evolution**: quản lý thay đổi schema bằng cách phân biệt thay đổi an toàn với breaking change. Thay đổi schema là thay đổi hợp đồng giữa các hệ thống, không đơn thuần là đổi cấu trúc một bảng.
- **Schema registry**: hỗ trợ quản lý phiên bản và kiểm tra tương thích cho event streaming.
- **Data Quality Gate**: cơ chế quyết định một dataset hoặc một bước xử lý có được đi tiếp hay không, dựa trên tiêu chí chất lượng đã xác định. Có 3 nhóm: Hard Gate, Soft Gate, Quarantine.
- **Quarantine**: cách ly bản ghi không hợp lệ để điều tra, sửa, nạp lại. Cách ly không đồng nghĩa với bỏ qua lỗi.
- **Lỗi dữ liệu vs lỗi xử lý kỹ thuật**: một bản ghi vi phạm quy tắc nghiệp vụ khác với việc mất kết nối database hoặc pipeline hết tài nguyên — hai loại phải xử lý khác nhau.
- **Data Testing**: 6 lớp kiểm thử (Schema, Unit, Data Quality, Integration, Reconciliation, Contract Testing), tích hợp vào vòng đời phát triển như kiểm thử phần mềm.
- **Contract Testing**: kiểm tra producer có đáp ứng Data Contract và consumer có tương thích với phiên bản hợp đồng hay không.
- **Vai trò ownership**: Data Producer/Source Owner, Data Owner, Data Steward, Data Platform Team, Data Consumer (bảng ảnh 3).
- **Data Observability**: một nhóm năng lực khác, quan sát trạng thái vận hành; không bị DQ/DC thay thế.

**4. Kiến trúc, pattern & quy trình**
- **DQ theo Medallion** (không áp cùng mức kiểm soát ở mọi tầng):
  - *Bronze – kiểm soát dữ liệu đầu vào*:
    - khả năng đọc và giải mã dữ liệu;
    - cấu trúc tối thiểu để tiếp nhận;
    - phát hiện bản ghi lỗi định dạng hoặc không parse được;
    - kiểm tra thông tin nguồn, thời điểm tiếp nhận, định danh lô;
    - phát hiện thay đổi schema có thể ảnh hưởng xử lý.
    - Không mặc định loại bỏ mọi bản ghi vi phạm quy tắc nghiệp vụ tại Bronze; giữ dữ liệu gốc và dấu vết lỗi để điều tra, nạp lại.
  - *Silver – chuẩn hóa & bảo đảm nhất quán* (phần lớn quy tắc cấp bản ghi):
    - chuẩn hóa kiểu dữ liệu, mã trạng thái, định dạng ngày giờ;
    - xử lý hoặc phân loại bản ghi trùng;
    - kiểm tra khóa nghiệp vụ và tính duy nhất;
    - kiểm tra quan hệ giữa các thực thể;
    - chuẩn hóa mã khách hàng, sản phẩm, đơn vị đo;
    - áp dụng quy tắc nghiệp vụ đã được phê duyệt.
    - Bản ghi lỗi được cách ly vào vùng dữ liệu lỗi thay vì loại bỏ không dấu vết.
  - *Gold – bảo đảm sẵn sàng cho nghiệp vụ*:
    - đối soát số bản ghi và tổng giá trị nghiệp vụ;
    - kiểm tra tính đúng đắn của các chỉ số quan trọng;
    - kiểm tra nhất quán giữa bảng fact và dimension;
    - kiểm tra quy tắc tổng hợp và phân loại nghiệp vụ;
    - bảo đảm dữ liệu đáp ứng tiêu chí đã cam kết với hệ thống tiêu thụ.
  - Không phải quy tắc nào cũng cần lặp ở cả ba tầng: đặt kiểm tra ở nơi có đủ ngữ cảnh để đánh giá và xử lý hiệu quả nhất.
- **Quality Gate**: `Source → Bronze → Quality Checks → Pass → Silver | Fail → Quarantine → Investigation → Correct/Replay`.
- **Data Testing trong CI/CD**: `Developer changes → Code Review → Schema/Contract Validation → Unit & Data Tests → Integration Tests → Deployment Approval → Production Deployment`.
- **Kiến trúc tham chiếu cho enterprise**: `Data Producers (DB/API/Files/Events) → Data Ingestion Layer → Bronze → [Schema Validation + Contract Checks] → Silver → [Quality Rules + Referential Checks] → Quality Gate → Pass: Gold → Data Products → BI/Analytics/AI | Fail: Quarantine`.
- **7 năng lực dùng chung**:
  1. *Data Quality Rule Management* — danh mục quy tắc, phiên bản, ngưỡng, mức nghiêm trọng, phạm vi áp dụng.
  2. *Data Contract Registry* — hợp đồng dữ liệu, schema, owner, phiên bản, cam kết giữa producer và consumer.
  3. *Validation Engine* — thực thi quy tắc trên dữ liệu và trả về kết quả có cấu trúc.
  4. *Quality Gate Framework* — áp dụng chính sách pass, fail, quarantine hoặc cho tiếp tục có điều kiện.
  5. *Metadata Integration* — liên kết dataset với định nghĩa nghiệp vụ, owner, contract, quality rules và hệ thống tiêu thụ.
  6. *Issue Management* — ghi nhận vi phạm, nguyên nhân, mức ảnh hưởng, người chịu trách nhiệm, trạng thái khắc phục.
  7. *CI/CD Integration* — kiểm tra schema, contract, data tests trước khi triển khai lên môi trường chính thức.
- **Tách định nghĩa quy tắc khỏi thực thi quy tắc**: nhờ đó dùng chung một bộ nguyên tắc cho nhiều pipeline thay vì sao chép logic kiểm tra sang từng dự án. Tuy vậy, quy tắc đặc thù (cách tính doanh thu, phân loại giao dịch, xác định khách hàng hợp lệ) vẫn được quản lý theo từng miền nghiệp vụ.

**5. Framework ra quyết định & so sánh**

Ảnh 1 — Các chiều chất lượng:

| Chiều chất lượng | Ý nghĩa | Ví dụ kiểm soát |
|---|---|---|
| Accuracy | Độ chính xác | Số dư trên Data Warehouse khớp với nguồn chuẩn |
| Completeness | Tính đầy đủ | Không thiếu mã khách hàng bắt buộc |
| Consistency | Tính nhất quán | Một khách hàng có cùng định danh giữa các hệ thống |
| Validity | Tính hợp lệ | Ngày giao dịch, trạng thái, số tiền tuân thủ quy tắc |
| Uniqueness | Tính duy nhất | Không có hai bản ghi cùng mã giao dịch trong phạm vi khóa nghiệp vụ |
| Referential Integrity | Toàn vẹn tham chiếu | Giao dịch phải tham chiếu đến khách hàng hợp lệ |
| Timeliness | Tính kịp thời | Dữ liệu đáp ứng thời hạn phục vụ báo cáo |

Ảnh 2 — Thành phần của Data Contract:

| Thành phần | Nội dung |
|---|---|
| Data Schema | Tên trường, kiểu dữ liệu, nullable, cấu trúc và quy tắc schema |
| Semantics | Ý nghĩa nghiệp vụ của dữ liệu và từng trường |
| Quality Rules | Các tiêu chí chất lượng bắt buộc |
| Delivery Expectations | Tần suất cập nhật và thời hạn cung cấp |
| Compatibility | Quy tắc thay đổi schema và tính tương thích ngược |
| Ownership | Producer, owner và đầu mối chịu trách nhiệm |
| Security | Phân loại dữ liệu, quyền truy cập và các yêu cầu bảo vệ |
| Failure Handling | Cách thông báo, xử lý và khôi phục khi vi phạm cam kết |

Ảnh 3 — Vai trò & trách nhiệm (một người có thể kiêm nhiều vai trò tùy quy mô; quan trọng là có đầu mối xử lý khi vi phạm):

| Vai trò | Trách nhiệm chính |
|---|---|
| Data Producer / Source Owner | Cung cấp dữ liệu theo hợp đồng và giải quyết lỗi phát sinh từ nguồn |
| Data Owner | Chịu trách nhiệm về ý nghĩa, chính sách và chất lượng dữ liệu thuộc phạm vi quản lý |
| Data Steward | Quản lý định nghĩa, quy tắc nghiệp vụ và metadata |
| Data Platform Team | Cung cấp framework, cơ chế thực thi và khả năng kiểm soát chất lượng |
| Data Consumer | Xác định yêu cầu sử dụng và phản hồi khi dữ liệu không đáp ứng nhu cầu |

Các loại Quality Gate (bảng tổng hợp từ §7):

| Loại | Khi áp dụng | Ví dụ |
|---|---|---|
| Hard Gate – chặn xử lý | Vi phạm có thể làm sai lệch nghiêm trọng kết quả nghiệp vụ | Khóa định danh bị trùng trong dataset yêu cầu duy nhất tuyệt đối; dữ liệu tài chính không đạt quy tắc đối soát bắt buộc |
| Soft Gate – cho tiếp tục có kiểm soát | Lỗi nằm trong ngưỡng chấp nhận hoặc chưa ảnh hưởng các cam kết quan trọng | Một số thuộc tính mô tả có tỷ lệ thiếu nhỏ hơn ngưỡng được phê duyệt |
| Quarantine – cách ly | Cần giữ bản ghi không hợp lệ để điều tra, sửa chữa, nạp lại | Vẫn phải ghi nhận số bản ghi bị cách ly, nguyên nhân, trạng thái xử lý |

Thay đổi schema (bảng tổng hợp từ §6):

| Thường ít rủi ro | Có thể phá vỡ consumer |
|---|---|
| Thêm trường tùy chọn, có giá trị mặc định, hoặc bổ sung tương thích với consumer hiện tại (vd. `channel`) | Xóa trường consumer đang dùng; đổi tên không có phương án chuyển tiếp; đổi kiểu dữ liệu không tương thích; đổi ý nghĩa nghiệp vụ nhưng giữ nguyên tên trường; đổi đơn vị đo hoặc cách tính chỉ số; thêm trường **bắt buộc** (consumer cũ không đọc được dữ liệu mới) |

DQ & Data Contract vs Data Observability (bảng tổng hợp từ mục "Phân biệt với Data Observability"):

| | DQ & Data Contract | Data Observability |
|---|---|---|
| Câu hỏi | Dữ liệu phải đáp ứng tiêu chuẩn nào? Các hệ thống cam kết gì? Làm sao kiểm tra, ngăn chặn, xử lý dữ liệu vi phạm? | Điều gì đang xảy ra trên toàn platform? Pipeline, dữ liệu, hiệu năng, chi phí biến động ra sao? Làm sao phát hiện bất thường, phân tích nguyên nhân, nâng hiệu quả vận hành? |
| Vai trò | Xác định và thực thi tiêu chuẩn cần tuân thủ | Quan sát, hiểu trạng thái vận hành để phát hiện và xử lý vấn đề |

- **Fit-for-purpose**: bảng phục vụ báo cáo tài chính cần độ chính xác và khả năng đối soát rất cao; dữ liệu hành vi người dùng để phân tích xu hướng có thể chấp nhận một tỷ lệ thiếu nhất định. Tiêu chí dựa trên mục đích sử dụng, mức độ quan trọng, rủi ro nghiệp vụ.
- **Công cụ cho schema evolution**: event streaming → schema registry; dữ liệu bảng/file → CI/CD, metadata catalog hoặc công cụ kiểm soát dữ liệu.
- **Chính sách gate theo workload**: pipeline báo cáo quản trị có thể dùng chính sách khác với pipeline báo cáo tài chính hoặc quyết toán.
- **Quy tắc dùng chung vs đặc thù domain**: nguyên tắc chất lượng chung được tái sử dụng qua nhiều pipeline; quy tắc tính doanh thu, phân loại giao dịch, khách hàng hợp lệ thuộc từng miền nghiệp vụ.

**6. Best practices / nguyên tắc thiết kế**
- Chọn tiêu chí có ý nghĩa với từng Data Product, thay vì lập danh sách dài áp chung cho mọi bảng.
- Chuyển yêu cầu nghiệp vụ thành quy tắc kiểm tra tự động, có phạm vi áp dụng và cách xử lý khi vi phạm; quản lý rule như thành phần có vòng đời (8 thuộc tính).
- Đặt ngưỡng và severity theo mức quan trọng: trùng mã giao dịch → ngưỡng 0, Critical; thuộc tính mô tả → cho phép NULL < 2%.
- Đặt kiểm tra đúng tầng; giữ dữ liệu gốc và dấu vết lỗi ở Bronze; cách ly thay vì xóa.
- Ở Gold, đối soát theo cùng phạm vi thời gian, trạng thái giao dịch, tiền tệ và quy tắc ghi nhận với nguồn chuẩn.
- Data Contract phải kiểm tra và thực thi được; thay đổi không tương thích phải được thông báo và phê duyệt trước khi áp dụng.
- Quản lý schema evolution theo quy trình 6 bước; triển khai theo phiên bản khi có breaking change; luôn có phương án rollback.
- Thiết kế gate theo mức nghiêm trọng và phạm vi ảnh hưởng: không phải lỗi nào cũng dừng toàn pipeline. Phân biệt lỗi dữ liệu với lỗi kỹ thuật.
- Quarantine phải ghi nhận số bản ghi, nguyên nhân và trạng thái xử lý.
- Tích hợp kiểm thử dữ liệu vào CI/CD; xác minh kết quả tính toán theo các tình huống nghiệp vụ, không chỉ việc câu SQL chạy được.
- Xác định yêu cầu kiểm soát trước rồi mới chọn công cụ phù hợp hệ sinh thái hiện có; không nhất thiết mỗi lớp kiểm thử một công cụ riêng.
- Quản lý phiên bản các quy tắc quan trọng cùng code và cho phép chạy lại trong môi trường kiểm thử → thay đổi minh bạch, review được, tái lập được.
- Xác định rõ ownership; liên kết thông tin chất lượng với metadata của dataset và quản lý tập trung.
- Thiết kế DQ & DC thành năng lực dùng chung của platform; tách phần định nghĩa khỏi phần thực thi quy tắc.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Coi pipeline chạy thành công là dữ liệu đúng.
- Coi DQ là bước kiểm tra phụ, viết SQL rải rác trong từng pipeline.
- Hiểu DQ chỉ là không NULL và không lỗi định dạng.
- Áp một bộ quy tắc giống nhau cho mọi bảng; xây danh sách tiêu chí thật dài mà không gắn với mục đích sử dụng.
- Áp rule cứng không tính ngoại lệ (giao dịch hoàn tiền có thể mang giá trị âm hợp lệ).
- Loại bỏ ngay tại Bronze mọi bản ghi không đạt quy tắc nghiệp vụ; loại bỏ bản ghi lỗi mà không để lại dấu vết.
- Lặp mọi quy tắc ở cả ba tầng.
- Coi Data Contract chỉ là một file JSON mô tả schema.
- Producer thay đổi cấu trúc bảng, đổi tên trường, đổi ý nghĩa mã trạng thái hoặc thời điểm cập nhật mà không thông báo và kiểm soát → làm hỏng hàng loạt pipeline và báo cáo phía sau.
- Cho rằng thêm trường mới luôn an toàn; đổi ý nghĩa nghiệp vụ nhưng giữ nguyên tên trường.
- Coi thay đổi schema chỉ là thay đổi cấu trúc một bảng.
- Phát hiện lỗi nhưng vẫn để dữ liệu sai đi vào các tầng sau; hoặc ngược lại, để mọi lỗi dừng toàn bộ pipeline.
- Coi quarantine là bỏ qua lỗi.
- Gộp chung lỗi dữ liệu với lỗi xử lý kỹ thuật.
- Chỉ kiểm tra DQ sau khi pipeline đã triển khai lên production.
- Không xác định rõ ai chịu trách nhiệm: platform team có công cụ nhưng không hiểu hết nghiệp vụ, đội nghiệp vụ hiểu dữ liệu nhưng không vận hành pipeline. Đây là nguyên nhân phổ biến khiến chương trình DQ thất bại.
- Để từng nhóm tự định nghĩa và kiểm soát dữ liệu theo cách riêng; sao chép logic kiểm tra sang từng dự án.
- Để chất lượng phụ thuộc vào việc từng kỹ sư có nhớ viết câu kiểm tra hay không.
- Nhầm DQ/DC với Data Observability.

**8. Ví dụ minh họa**
- Bài 6 **không** dùng kịch bản công ty chứng khoán (không có Oracle Core, ORDERS, POSITION, MARGIN…). Các ví dụ mang tính tổng quát về giao dịch/bán hàng.
- 10.000 giao dịch/ngày, 500 giao dịch bị nhân đôi do lỗi chuyển đổi → doanh thu cao hơn thực tế dù ELT thành công.
- `transaction_amount = -500000`: hợp lệ về kiểu NUMERIC nhưng không hợp lệ nếu hệ thống không cho phép giao dịch âm trong trường hợp đó.
- **Yêu cầu nghiệp vụ → rule**: mỗi giao dịch có mã định danh duy nhất; giao dịch đã hoàn tất phải có thời điểm hoàn tất; mọi giao dịch thuộc về một khách hàng hợp lệ; tổng tiền giao dịch sau khi nạp khớp với nguồn trong phạm vi đối soát đã thống nhất.
- **4 câu SQL trên `fact_transactions`** (chỉ minh họa):
  1. đếm bản ghi có `transaction_id IS NULL`;
  2. `GROUP BY transaction_id HAVING COUNT(*) > 1` để tìm mã trùng;
  3. đếm bản ghi `status = 'COMPLETED'` mà `completed_at IS NULL`;
  4. đếm bản ghi có `transaction_amount IS NULL` hoặc `< 0` — lưu ý giao dịch hoàn tiền có thể âm hợp lệ.
- **Ngưỡng**: trùng mã giao dịch → ngưỡng 0, severity Critical; thuộc tính mô tả → cho phép NULL < 2%.
- **Gold**: tổng doanh thu đối soát theo cùng phạm vi thời gian, trạng thái giao dịch, tiền tệ, quy tắc ghi nhận với nguồn chuẩn.
- **Data Contract cho dataset `transactions`** của một hệ thống giao dịch:
  - `transaction_id` bắt buộc và duy nhất trong phạm vi đã thống nhất;
  - `transaction_amount` dùng đơn vị tiền tệ được xác định rõ;
  - `status` chỉ nhận giá trị thuộc danh mục được công bố;
  - dữ liệu được cập nhật trong khoảng thời gian đã thỏa thuận;
  - thay đổi schema không tương thích phải được thông báo và phê duyệt trước khi áp dụng.
- **Schema evolution**: `transactions(transaction_id, customer_id, transaction_amount, status)`, producer muốn thêm `channel` (giao dịch tại quầy, trên web, trên ứng dụng di động) — ít rủi ro nếu là trường tùy chọn, có giá trị mặc định hoặc tương thích với consumer hiện tại.
- **Data testing**: khi developer đổi logic tính doanh thu, bộ test phải xác minh kết quả tính toán theo các tình huống nghiệp vụ đã định nghĩa, không chỉ việc SQL chạy thành công.

**9. Công nghệ/công cụ được nhắc tới**
- **SQL, Python, dbt tests, Great Expectations, Soda** (hoặc công cụ tương đương): triển khai kiểm tra và kiểm thử dữ liệu; không nhất thiết mỗi lớp kiểm thử một công cụ.
- **Schema registry**: quản lý phiên bản và kiểm tra tương thích cho event streaming.
- **CI/CD, metadata catalog, công cụ kiểm soát dữ liệu**: kiểm soát thay đổi schema cho dữ liệu bảng/file.
- **Data Warehouse, ELT** (ví dụ mở đầu); **JSON** (tác giả nhấn mạnh hợp đồng không chỉ là file JSON).

**10. Checklist / câu hỏi thiết kế**
- **8 thuộc tính tối thiểu của một DQ Rule**: Rule ID, Business Meaning, Scope, Evaluation Logic, Threshold, Severity, Failure Action, Owner.
- **Quy trình schema evolution 6 bước**:
  1. đề xuất thay đổi và xác định lý do nghiệp vụ;
  2. phân tích ảnh hưởng tới producer, consumer và các Data Product liên quan;
  3. kiểm tra tương thích schema tự động;
  4. thông báo và thống nhất thời điểm triển khai;
  5. triển khai theo phiên bản nếu thay đổi không tương thích;
  6. kiểm tra dữ liệu sau thay đổi, có phương án rollback.
- **6 lớp kiểm thử**: Schema Testing (cấu trúc, kiểu dữ liệu); Unit Testing (logic chuyển đổi trên tập dữ liệu nhỏ); Data Quality Testing (NULL, uniqueness, validity, quy tắc nghiệp vụ); Integration Testing (dữ liệu đi qua nhiều bước); Reconciliation Testing (đối soát nguồn–đích); Contract Testing.
- **Metadata cần liên kết với dataset (8 mục)**: Business Definition; Data Owner & Technical Owner; Schema & Data Contract Version; các DQ Rules đang áp dụng; phạm vi dữ liệu & nguồn gốc; mức độ quan trọng; chính sách truy cập & phân loại dữ liệu; consumer & các Data Product phụ thuộc.
- **7 năng lực dùng chung** (mục 4) và **danh sách kiểm tra theo tầng**: Bronze (5) / Silver (6) / Gold (5).

**11. Kết luận & key takeaways**
- Data Platform không chỉ tiếp nhận, lưu trữ, xử lý dữ liệu mà còn phải bảo đảm dữ liệu đáp ứng yêu cầu đã thống nhất và đủ tin cậy để sử dụng.
- Ba thành phần phối hợp: DQ (quy tắc rõ ràng) + Data Contract (thỏa thuận về cấu trúc, ý nghĩa, chất lượng và quản lý thay đổi) + Quality Gates & Data Testing (đưa vào quy trình xử lý và phát triển).
- Khi triển khai đúng, chất lượng không còn phụ thuộc vào trí nhớ của từng kỹ sư; tiêu chí và cam kết trở thành phần quản lý được, kiểm thử được, thực thi được của kiến trúc.
- Ownership rõ ràng và metadata tập trung là nền để mở rộng từ chất lượng cấp bảng lên cấp Data Product và miền dữ liệu toàn doanh nghiệp.
- DQ/DC xác định và thực thi tiêu chuẩn; Data Observability quan sát trạng thái vận hành. Hai nhóm bổ trợ nhau, không thay thế nhau.
- Trích: *"Xét về mặt kỹ thuật, pipeline đã hoàn thành. Nhưng xét về mặt nghiệp vụ, Data Platform đã thất bại."*
- Trích: *"…xác định rõ dữ liệu phải đáp ứng những tiêu chuẩn nào trước khi được tin cậy để sử dụng."*

**12. Liên kết với các bài khác**
- **Nhìn lại**: các bài trước về ingestion (Batch, Incremental, CDC, Streaming), Medallion Architecture (Bài 4) và điều phối pipeline (Bài 5).
- **Đào sâu Bài 4**: §8.1 (DQ theo layer) và §9 (mô hình vai trò — Bài 6 bổ sung vai trò Data Platform Team và gắn vai trò với Data Contract).
- **Cụ thể hóa Bài 5**: điều kiện publish (freshness, completeness, business rule), Quality Metadata và bảng `data_quality_rule` trở thành Quality Gate Framework và Rule Management.
- **Khác với lời hẹn ở Bài 5**: Bài 5 hẹn "Data Quality & Observability", nhưng Bài 6 tập trung vào DQ & Data Contract và tách riêng Observability qua mục "Phân biệt với Data Observability" → báo hiệu Observability là chủ đề của một bài sau.
- **"Series tiếp theo"** hẹn các chủ đề: kiến trúc xử lý dữ liệu, quản lý metadata, quản trị dữ liệu, khả năng quan sát (observability), tối ưu hiệu năng và kiểm soát chi phí trên toàn nền tảng.


---

## Chủ đề xuyên suốt (từ các bài được giao)
- **"Chạy thành công" khác với "dữ liệu đúng"**:
  - Bài 4: Gold phải có định nghĩa chỉ số, `as_of_time` và quy tắc tính.
  - Bài 5: `gold_risk` phải qua kiểm tra freshness, completeness và business rule rồi mới được publish.
  - Bài 6: ví dụ 500 giao dịch bị nhân đôi dù ELT thành công.
  - Cả ba bài đều coi tính đúng về nghiệp vụ là thước đo cuối cùng.
- **Thiết kế cho lỗi và chạy lại ngay từ đầu**:
  - Bronze giữ dữ liệu gốc để reprocess.
  - Idempotency dựa trên business key + MERGE/UPSERT, batch ID, record hash, và chỉ commit watermark sau khi ghi thành công (Bài 4, Bài 5).
  - Backfill có kiểm soát phạm vi (Bài 5); Quarantine → Investigation → Correct/Replay (Bài 6).
  - Rollback code/metadata không tự hoàn tác dữ liệu đã ghi sai.
- **Tách lớp logic khỏi phần hiện thực**:
  - Logical layer vs physical storage, chỉ materialize khi có lý do (Bài 4).
  - Code vs Metadata vs Orchestrator, Control Plane vs Data Plane (Bài 5).
  - Định nghĩa quy tắc vs thực thi quy tắc, Contract Registry vs Validation Engine (Bài 6).
- **Ownership, metadata và governance là nền tảng, không phải phần phụ**:
  - Bảng vai trò (Source owner/Producer, Data owner, Steward, Platform/Engineering, Consumer) xuất hiện ở cả Bài 4 và Bài 6.
  - 7 nhóm metadata và Data Control Plane (Bài 5); metadata liên kết với dataset (Bài 6).
  - Lineage dùng để phân tích ảnh hưởng khi dữ liệu sai hoặc schema thay đổi.
- **Chính sách theo ngữ cảnh và mức độ quan trọng, không "một cỡ cho tất cả"**:
  - Quy tắc DQ theo loại giao dịch (Bài 4); SLA, priority, resource pool (Bài 5); Hard/Soft Gate và ngưỡng theo từng Data Product (Bài 6).
  - Mọi con số (slot, SLA, tần suất, 30 TB, NULL < 2%) đều được tác giả nói rõ chỉ là minh họa.
  - Kiến trúc tiến hóa theo quy mô (Stage 1 → 5), không over-engineer từ ngày đầu.
- **Quản lý như code, kiểm soát thay đổi, ưu tiên dùng chung**:
  - Metadata as Code + CI/CD + phát hiện circular dependency (Bài 5); contract/data testing trong CI/CD (Bài 6); quản lý thay đổi xuyên layer (Bài 4).
  - Ưu tiên tài sản dùng chung thay vì mỗi team một bản sao: Silver dùng chung, reusable framework, năng lực DQ/DC dùng chung.



---

# Tóm tắt Bài 7 và Bài 8: series "Modern Data Platform" (Duong Pham)

Nguồn: `bai07.md` (634 dòng) và `bai08.md` (1242 dòng), đã đọc hết, cùng toàn bộ 10 ảnh bảng. Nội dung ảnh được đưa vào các bảng bên dưới.

## Bài 7: Source-to-Lakehouse Ingestion – Thiết kế chiến lược nạp dữ liệu từ hệ thống nguồn
*Tên đầy đủ: "Modern Data Platform – Bài 7: Source-to-Lakehouse Ingestion – Thiết kế chiến lược nạp dữ liệu từ hệ thống nguồn" · Subtitle: Data Ingestion Engineering · Tagline: From Source Systems to Reliable Data Ingestion · Đăng 07/10/2026 · 3 bảng dạng ảnh, đã đọc hết.*

Mục lục (H2): 1. Bài toán thực tế: Data Ingestion không chỉ là copy table | 2. Xác định data freshness trước khi chọn công nghệ | 3. Xây dựng Ingestion Strategy Matrix cho từng bảng | 4. Full Load và Incremental Load: hai lựa chọn cơ bản | 5. Watermark, extraction boundary và khả năng phục hồi | 6. Khi source không có `UPDATED_AT`: những lựa chọn thực tế | 7. CDC: chuyển từ đọc trạng thái sang capture thay đổi | 8. Bảo đảm tính nhất quán giữa source và target | 9. Thiết kế pipeline ingestion thực tế cho Oracle/Tibero và Microsoft Fabric | 10. Kết luận: chọn ingestion strategy dựa trên dữ liệu, không dựa trên xu hướng

**1. Bối cảnh & vấn đề mở đầu**
- Bài mở đầu bằng phần tóm tắt Bài 1–6. Sau đó tác giả nêu câu hỏi còn lại khi triển khai thực tế: làm sao đưa dữ liệu từ source vào Data Platform một cách hiệu quả, đầy đủ, nhất quán và đúng yêu cầu business.
- Bối cảnh là một công ty chứng khoán:
  - Source: Oracle Core, Tibero, PostgreSQL, các hệ thống giao dịch, Customer/Order/Risk Management, API và Market Data.
  - Consumer: BI, Regulatory Reporting, Risk Analytics, Data Science và AI.
- Khâu nằm giữa là **Data Ingestion Engineering**. Đây không phải việc copy table. Nó gồm thiết kế cách đọc dữ liệu, xác định phần cần lấy, không bỏ sót thay đổi, xử lý lỗi và kiểm soát độ trễ từ source đến consumer.

**2. Luận điểm cốt lõi**
- Ingestion phải được thiết kế **theo từng bảng**, không theo xu hướng công nghệ. Căn cứ là:
  - đặc điểm dữ liệu: volume, change rate, hành vi update/delete, khả năng của source;
  - yêu cầu business: freshness, consistency.
- Độ tin cậy đến từ ba điều: xác định đúng phạm vi extract, ghi nhận tiến độ chính xác (watermark/checkpoint) và có khả năng phục hồi. Có nhiều cơ chế ingestion không làm nên độ tin cậy.

**3. Khái niệm chính**
- **Ba khái niệm về thời gian:**
  - Data freshness: dữ liệu ở đích cũ đến mức nào so với source.
  - Processing latency: thời gian cần để xử lý một lượng dữ liệu.
  - Scheduling interval: khoảng cách giữa các lần bắt đầu chạy pipeline.
- **Frequent batch / micro-batch:** pipeline chạy định kỳ với chu kỳ ngắn (ví dụ 5 phút). Cách này không đồng nghĩa với Streaming.
- **Ingestion Strategy Matrix:** danh mục bảng nguồn kèm chiến lược ingestion cho từng bảng. Nó đóng vai trò metadata cho các pipeline template.
- **Full Load:** đọc toàn bộ bảng trong mỗi lần chạy.
- **Incremental Load:** chỉ lấy phần dữ liệu thay đổi, dựa trên một trường đáng tin cậy như `UPDATED_AT`.
- **Watermark:** giá trị mốc xác định vị trí hoặc phạm vi cần xử lý tiếp.
- **Extraction boundary:** điểm đầu và điểm cuối của một đợt extract. Điểm cuối được xác định an toàn (`determine_safe_boundary`).
- **Checkpoint:** tiến độ đã được ghi nhận để phục hồi hoặc chạy tiếp. Checkpoint chỉ có ý nghĩa khi biết chính xác nó đại diện cho điều gì.
- **Batch ID / Run ID:** định danh từng đợt extract để truy vết.
- **Lookback window:** đọc chồng lấn lại một khoảng gần nhất để bắt dữ liệu đến muộn.
- **Snapshot comparison:** so sánh hai snapshot để suy ra bản ghi mới, bản ghi thay đổi và bản ghi bị mất.
- **CDC:** đọc change log hoặc transaction log để capture INSERT/UPDATE/DELETE, thay vì suy luận từ trạng thái hiện tại. Một **change event** có thể chứa key, loại thao tác, dữ liệu before/after và vị trí trong log.
- **Initial load/snapshot:** bước đồng bộ trạng thái ban đầu trước khi capture thay đổi liên tục.
- **Snapshot consistency:** đọc nhất quán để không lấy về các trạng thái không tương thích của cùng một nghiệp vụ.
- **Ingestion completed ≠ Data product ready:**
  - Ingestion completed: dữ liệu đã được đọc và ghi vào vùng đích của ingestion.
  - Data product ready: dữ liệu đã qua xử lý, kiểm tra và được publish cho consumer.

**4. Kiến trúc, pattern & quy trình**
- **Kiến trúc đơn giản ban đầu:** `Oracle Core / Tibero / PostgreSQL → Data Ingestion → Lakehouse → Data Platform`. Thoạt nhìn chỉ cần `SELECT` rồi ghi. Khi lên production, hàng loạt câu hỏi phát sinh (xem mục 10).
- **Full Load:** `Source Table → Full Extract → Target Table`.
- **Chu trình checkpoint:** `Previous checkpoint 10:00 → Extract window 10:00–10:05 → Commit progress`. Gồm 5 bước:
  1. Đọc checkpoint đã lưu.
  2. Xác định extraction boundary mới.
  3. Đọc dữ liệu trong phạm vi đó.
  4. Ghi vào đích và xác nhận kết quả.
  5. Chỉ cập nhật checkpoint khi đã đạt điều kiện hoàn thành.
- Pseudocode minh họa: `load_checkpoint → determine_safe_boundary → extract(start, end) → write_to_bronze → verify_ingestion_commit → save_checkpoint`.
- **Phân vai với Bài 5:**
  - Orchestration lo điều phối lần chạy, retry và trạng thái thực thi.
  - Bài 7 lo semantics dữ liệu: cần extract khoảng nào và xác định tiến độ ra sao.
- **Snapshot comparison:** `Snapshot T1 → Compare with T2 → New / Changed / Missing records`.
- **Luồng CDC:** `Oracle/Tibero → Transaction/Change Log → CDC Connector → Change Events → Bronze → Apply Changes/Merge → Silver`.
- **Kiến trúc tham chiếu (mục 9):** `Oracle Core {ORDER, TRANSACTION, POSITION → Incremental/CDC} + Tibero {ACCOUNT, CUSTOMER, REFERENCE → Full/Incremental} → INGESTION LAYER (Extract/Capture Changes; Watermark/Log Position) → BRONZE → Silver Transformation/Merge → GOLD → Power BI | Risk/APIs`.

Trách nhiệm của từng tầng:

| Tầng | Trách nhiệm |
|---|---|
| Source | Xác định bảng, khóa nghiệp vụ, volume, change rate, khả năng capture; đánh giá tác động của extract lên DB production; chọn chiến lược cho từng bảng |
| Ingestion layer | Chạy Full/Incremental/CDC theo cấu hình; quản lý boundary, watermark, log position; ghi batch ID, run ID, metadata truy vết; bảo đảm retry, replay, phục hồi |
| Bronze | Lưu dữ liệu source-aligned; giữ metadata ingestion để điều tra sự cố; nếu cần lịch sử thay đổi thì lưu CDC event hoặc snapshot, không chỉ giữ trạng thái hiện tại |
| Silver/Gold | Apply changes vào mô hình đích; chuẩn hóa, kết hợp dữ liệu; kiểm tra trước khi publish |

**5. Framework ra quyết định & so sánh**

*Ảnh 1: Các yếu tố làm cùng một bảng ORDER có cách ingestion khác nhau*

| Yếu tố | Ví dụ |
|---|---|
| Data volume | 100 nghìn hay 100 triệu records |
| Change rate | 100 hay 100.000 records thay đổi mỗi phút |
| Latency requirement | Hằng ngày, 15 phút hay vài giây |
| Source capability | Có timestamp, change log hay CDC |
| Update/delete behavior | Append-only hay thường xuyên sửa/xóa |
| Consistency requirement | Chấp nhận dữ liệu trễ hay cần snapshot nhất quán |
| Source impact | Truy vấn trực tiếp được hay phải hạn chế tải |

*Ảnh 2: Định hướng sơ bộ*

Đây không phải quy tắc cứng. CDC vẫn có thể xử lý theo micro-batch, và Streaming vẫn có thể cần các bước batch ở downstream.

| Yêu cầu | Phương án cần đánh giá |
|---|---|
| Dữ liệu nhỏ, ít thay đổi | Full Load theo lịch |
| Dữ liệu lớn, có timestamp đáng tin cậy | Incremental Load |
| Thay đổi liên tục, cần capture update/delete | CDC |
| Sự kiện cần xử lý liên tục, độ trễ thấp | Streaming |
| Cần cập nhật định kỳ trong vài phút | Frequent batch hoặc micro-batch |

*Ảnh 3: Ingestion Strategy Matrix (Oracle + Tibero, công ty chứng khoán)*

Tần suất trong bảng chỉ mang tính minh họa.

| Bảng | Đặc điểm | Chiến lược ban đầu | Tần suất tham khảo |
|---|---|---|---|
| HOLIDAY | Danh mục nhỏ | Full Load | Hằng ngày hoặc khi có thay đổi |
| BRANCH | Danh mục chi nhánh | Full hoặc Incremental | 15–60 phút hoặc theo nhu cầu |
| CUSTOMER | Có cập nhật thông tin | Incremental hoặc CDC | 15–30 phút |
| ACCOUNT | Có thay đổi trạng thái | Incremental hoặc CDC | 5–15 phút |
| ORDER | Volume lớn, nhiều thay đổi | Incremental hoặc CDC | 1–5 phút hoặc theo SLA |
| TRANSACTION | Volume lớn, cần kiểm soát lịch sử | Incremental hoặc CDC | Theo SLA |
| POSITION | Có thể là snapshot hoặc dữ liệu biến động | Tùy semantics của source | Theo SLA |
| MARKET_DATA | Có thể phát sinh liên tục | Streaming hoặc micro-batch | Theo yêu cầu |

*Bốn phương án khi source không có `UPDATED_AT` (mục 6)*

| Phương án | Dùng khi | Giới hạn |
|---|---|---|
| Incremental theo business date (`TXDATE`) | Bảng thật sự append-only, record không bị sửa/xóa | `TXDATE` là ngày phát sinh giao dịch, không phải thời điểm ghi/sửa. Giao dịch hôm qua bị sửa trạng thái hôm nay sẽ bị bỏ sót |
| Lookback window | Cần bắt thay đổi đến muộn hoặc ghi nhận trễ | Chỉ hiệu quả khi điều kiện truy vấn phủ được record. Lookback 10 phút không thấy record của nhiều tháng trước bị sửa. Đọc chồng lấn nên cần dedup hoặc cập nhật lại ở đích |
| Snapshot comparison | Không có timestamp, cũng không có change log | Tốn tài nguyên với bảng lớn. Nếu chỉ lưu key/hash thì hash có thể không đủ chứng minh hai trạng thái giống nhau. Chỉ phát hiện delete trong một số điều kiện. Không tái tạo được các sự kiện xảy ra giữa hai snapshot |
| CDC | Volume lớn, change rate cao, không có timestamp tin cậy, cần capture delete, cần thứ tự/lịch sử, latency thấp | Phải đánh giá DB, phiên bản, connector, log retention, quyền truy cập, tải thêm lên source. Oracle và Tibero không có cùng mức hỗ trợ |

- **Freshness không quyết định kiến trúc:**
  - Pipeline chạy mỗi 5 phút (10:00, 10:05, 10:10…) là frequent batch hoặc micro-batch.
  - Extract mất 2 phút và xử lý thêm 2 phút thì dữ liệu được publish khoảng 4 phút sau khi pipeline bắt đầu.
  - Freshness thực tế còn phụ thuộc thời điểm source commit, thời gian chờ lịch chạy và xử lý downstream.
  - Chỉ khi business cần cập nhật trong vài giây, với volume lớn và thay đổi liên tục, mới cần đánh giá CDC hoặc event streaming.
  - Yêu cầu 10 phút không có nghĩa phải xây Kafka từ đầu.
- **Full Load hay Incremental:**
  - Full Load hợp với bảng nhỏ (HOLIDAY vài trăm records): logic đơn giản, dễ kiểm tra, không cần watermark, dễ khôi phục, tránh lỗi incremental state.
  - Incremental hợp khi có cách xác định dữ liệu thay đổi đáng tin cậy.
- **Bộ tiêu chí ở phần kết luận:** latency, volume, change rate, consistency, khả năng của source, chi phí vận hành.

**6. Best practices / nguyên tắc thiết kế**
- Xác định freshness trước khi chọn công nghệ. Tách rõ freshness, processing latency và scheduling interval.
- Lập Ingestion Strategy Matrix với tối thiểu các trường: `source_system, source_schema, source_table, target_layer, load_strategy, primary_key, delete_capture, freshness_sla_minutes, initial_load, ongoing_load`.
  - Matrix giúp framework metadata-driven sinh nhiều pipeline từ một template.
  - Metadata chỉ mô tả cách pipeline vận hành; nó không thay thế việc đánh giá semantics dữ liệu.
- Hiểu nghĩa của từng bảng:
  - POSITION là trạng thái hiện tại hay snapshot theo thời điểm?
  - TRANSACTION có vẻ append-only, nhưng nếu source cho sửa/hủy giao dịch thì không thể chỉ dựa vào ngày giao dịch.
- Full Load vào Bronze khác với thay thế dữ liệu ở bảng đích:
  - Không mặc định truncate lịch sử.
  - Lưu mỗi lần extract thành một batch riêng, hoặc giữ một bản sao hiện tại, tùy yêu cầu.
  - Khi publish, không để consumer thấy dữ liệu dở dang.
- Chỉ dùng `UPDATED_AT` khi trường này phản ánh đúng thay đổi cần capture, đủ độ chính xác và độ trễ ghi timestamp không gây mất dữ liệu.
- Năm nguyên tắc checkpoint:
  1. Không tiến checkpoint trước khi dữ liệu được ghi nhận an toàn.
  2. Thiết kế retry và replay theo từng khoảng dữ liệu.
  3. Dùng batch ID/run ID.
  4. Kiểm soát duplicate bằng khóa nghiệp vụ hoặc cơ chế dedup.
  5. Tách checkpoint của ingestion khỏi trạng thái hoàn thành của downstream.
- Thiết kế cho trường hợp một thao tác thành công còn thao tác kia thất bại. Nếu đã ghi Bronze nhưng pipeline chết trước khi lưu checkpoint, lần sau chỉ phải đọc lại; không mất dữ liệu nếu có replay và cách ghi an toàn.
- Xác minh semantics của business date trước khi dùng làm watermark. Xác minh connector và phiên bản trước khi chốt CDC.
- Dùng cơ chế đọc snapshot nhất quán nếu source hỗ trợ. Với nhiều DB độc lập, xác định rõ mức consistency mà business chấp nhận.
- Đo end-to-end từ lúc source commit đến lúc consumer dùng được, gồm cả thời gian chờ lịch, extract, ghi và xử lý downstream.
- Trên Fabric, chọn connector và phương pháp theo loại source, phiên bản DB, giới hạn kết nối, latency, chi phí và khả năng vận hành.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Coi ingestion là copy table; coi Incremental chỉ là thêm điều kiện `WHERE`.
- Thấy yêu cầu cập nhật 5–10 phút là chuyển ngay sang Kafka/Streaming/CDC; đánh đồng latency business với kiến trúc xử lý; áp một chiến lược cho mọi bảng.
- Chỉ lưu thời điểm pipeline chạy gần nhất rồi mặc định mọi dữ liệu trước đó đã được xử lý.
- Tiến checkpoint trước khi dữ liệu được ghi bền vững, khiến một khoảng dữ liệu bị bỏ qua vĩnh viễn.
- Dùng ngày nghiệp vụ làm watermark trong khi record cũ vẫn có thể bị sửa.
- Tin rằng lookback ngắn bắt được cả sửa đổi cũ, hoặc quên xử lý dữ liệu trùng do đọc chồng lấn.
- Chạy snapshot comparison trên bảng rất lớn mà không tính chi phí; tin rằng hash là đủ.
- Truncate lịch sử Bronze khi Full Load; để consumer thấy trạng thái dở dang.
- Pipeline chạy thành công về mặt kỹ thuật nhưng dữ liệu đích sai hoặc thiếu. Ví dụ: ORDER và TRANSACTION được extract ở hai thời điểm không tương thích. Đây là vấn đề consistency, không phải scheduling. Không được mặc định các bảng lấy gần nhau về thời gian thì nhất quán.
- Tin rằng CDC tự bảo đảm downstream nhất quán. Thực tế vẫn phải xử lý thứ tự, duplicate, replay, delete, schema evolution và trạng thái ban đầu. Phối hợp snapshot với change log sai cách sẽ tạo khoảng trống hoặc mâu thuẫn.
- Mặc định mọi công cụ CDC hỗ trợ Oracle và Tibero như nhau, hoặc mọi DB Oracle/Tibero dùng chung một connector/kiểu CDC trên Fabric.
- Nghĩ rằng Fabric tự quyết định ingestion strategy.
- Nghĩ lịch chạy 5 phút nghĩa là dữ liệu chắc chắn được publish trong 5 phút.
- Nghĩ ingestion thành công nghĩa là data product đã sẵn sàng.

**8. Ví dụ minh họa**
- **ORDER:** 100 triệu records, khoảng 20.000 bản ghi được thêm/sửa mỗi 5 phút.
  - Checkpoint trước là 2026-10-21 10:00:00, nên window mới là 10:00–10:05.
  - Truy vấn `TRADING.ORDERS` với `UPDATED_AT` lớn hơn start và nhỏ hơn hoặc bằng end, ghi vào Bronze rồi xử lý downstream.
  - [Ghi chú: bài dùng lẫn tên ORDER và ORDERS.]
- **HOLIDAY:** vài trăm records, dùng Full Load.
- **TRANSACTION** (TXDATE, ACCTNO, AMT, STATUS…, không có `UPDATED_AT`):
  - Lọc `TXDATE` trong khoảng [start_date, end_date).
  - Với lookback: boundary trước là 10:00, boundary hiện tại là 10:05, nhưng đọc từ 09:55 đến 10:05.
- **ORDER_ID 1001:** đi từ NEW sang MATCHED, sau đó bị hủy/xóa.
  - Đọc trạng thái hiện tại chỉ thấy MATCHED, mất dấu NEW.
  - Khi record bị xóa, truy vấn bảng hiện tại không còn trả về nó.
  - Payload CDC minh họa gồm: operation UPDATE, order_id 1001, status_before NEW, status_after MATCHED. Đây không phải định dạng chuẩn.
- **Consistency:** ORDER (ORDER_ID, STATUS) và TRANSACTION (ORDER_ID, AMOUNT) được extract ở hai thời điểm không tương thích, nên đích phản ánh hai trạng thái khác nhau của cùng một nghiệp vụ.
- **Matrix mẫu:** ORACLE_CORE / TRADING / ORDER → BRONZE; load_strategy CDC; PK ORDER_ID; delete_capture true; freshness 5 phút; initial_load snapshot; ongoing_load change_capture.
- **Bài toán tổng hợp:** Oracle Core + Tibero, cần Order/Transaction/Position trong 5–10 phút. Lời giải là chọn chiến lược theo nhóm dữ liệu, không áp một chiến lược cho tất cả.

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle Core, Tibero, PostgreSQL:** hệ thống nguồn. Mức hỗ trợ CDC khác nhau, phải xác minh connector và phiên bản.
- **Kafka/Streaming:** thường bị chọn quá sớm. Chỉ cần khi yêu cầu ở mức vài giây, volume lớn, thay đổi liên tục.
- **CDC connector:** đọc transaction log/change log và phát ra change event.
- **Lakehouse với Bronze/Silver/Gold:** Bronze lưu dữ liệu source-aligned; Silver merge và chuẩn hóa; Gold publish.
- **Orchestration và metadata-driven framework (Bài 5):** điều phối, retry, sinh pipeline từ cấu hình.
- **Microsoft Fabric:** cung cấp thành phần nhưng không quyết định ingestion strategy thay Data Engineer.
  - Data Factory pipelines: điều phối và thực hiện tác vụ ingestion.
  - Connectors: kết nối source.
  - Lakehouse/OneLake: lưu trữ.
  - Spark/SQL: xử lý downstream.
  - Cơ chế CDC/streaming tương thích: dùng khi yêu cầu đòi hỏi.
- **Power BI, Risk/APIs:** consumer.

**10. Checklist / câu hỏi thiết kế**
- Bảy câu hỏi khi lên production:
  1. Bảng 100 triệu records có nên đọc lại toàn bộ mỗi lần chạy?
  2. Làm sao lấy đúng 20.000 bản ghi thay đổi?
  3. Không có `UPDATED_AT` thì xác định dữ liệu mới bằng cách nào?
  4. Phát hiện UPDATE/DELETE ra sao?
  5. Pipeline lỗi sau khi đã ghi một phần thì lần chạy sau xử lý thế nào?
  6. Source thay đổi trong lúc extract thì có bị bỏ sót không?
  7. Với SLA 5–10 phút, nên chọn Incremental hay CDC?
- Bảy yếu tố ở Ảnh 1, 10 trường của Matrix, chu trình checkpoint 5 bước và 5 nguyên tắc checkpoint (mục 6).
- Sáu điểm cân nhắc về consistency:
  1. Snapshot consistency khi extract.
  2. Phối hợp initial load với CDC.
  3. Thứ tự xử lý các thay đổi liên quan.
  4. Replay và deduplicate.
  5. Cách apply update/delete tại đích.
  6. Chỉ publish sau khi batch hoặc đơn vị công việc đã hoàn tất.
- Checklist trách nhiệm theo tầng: Source / Ingestion / Bronze / Silver–Gold (bảng ở mục 4).

**11. Kết luận & key takeaways**
- Không có phương pháp ingestion nào phù hợp cho mọi bảng:
  - Full Load cho bảng nhỏ.
  - Incremental khi có cách xác định thay đổi đáng tin cậy.
  - CDC khi cần capture chính xác hơn, đặc biệt với update/delete.
  - Streaming cho xử lý liên tục, độ trễ thấp.
- Watermark và checkpoint phải phản ánh đúng tiến độ dữ liệu. Cần có extraction boundary, cách xử lý dữ liệu đến muộn và điều kiện rõ ràng để tiến checkpoint.
- Ingestion thành công chưa có nghĩa data product đã sẵn sàng; dữ liệu còn phải được chuẩn hóa, kiểm tra, kết hợp và publish.
- Không phải yêu cầu cập nhật thường xuyên nào cũng cần Streaming. Quyết định dựa trên latency, volume, change rate, consistency, khả năng của source và chi phí vận hành.
- Consistency giữa nhiều bảng hoặc nhiều DB phải được thiết kế. Nó không tự có nhờ lịch chạy.
- Hai trích dẫn tiêu biểu:
  - «Business latency requirement và data processing architecture là hai khái niệm khác nhau.»
  - «Một Data Platform tốt không phải là platform có nhiều cơ chế ingestion nhất, mà là platform có thể đưa đúng dữ liệu…» (tức là đưa dữ liệu tới đúng chỗ, đúng lúc, có kiểm soát và phục hồi được).

**12. Liên kết với các bài khác**
- Mở bài tóm tắt Bài 1–6. Bài 7 cụ thể hóa 4 phương pháp ingestion của Bài 2 ở mức từng bảng.
- **Bài 4 (Medallion):** dùng luồng Bronze (source-aligned) → Silver (merge) → Gold (publish).
- **Bài 5:** Matrix là metadata cho pipeline metadata-driven. Bài này cũng phân ranh giới giữa orchestration (run/retry/state) và semantics dữ liệu.
- **Bài 6:** mục 8 viết rằng Bài 6 "sẽ" giải thích sâu hơn về data quality. [Ghi chú: tác giả dùng thì tương lai dù Bài 6 đã đăng trước; có thể là lỗi tham chiếu.]
- **Mở đường cho Bài 8:** CDC Architecture – Từ Transaction Log đến Near-Real-Time Data Pipeline. Các câu hỏi được đặt ra: INSERT/UPDATE/DELETE được capture ra sao, transaction log được đọc thế nào, và làm sao chuyển thay đổi thành event rồi apply vào Lakehouse mà không bỏ sót hoặc sai thứ tự. Mục 7 đã báo trước rằng CDC đủ lớn để thành một bài riêng.

---


## Bài 8: CDC Architecture – Từ Transaction Log đến Near-Real-Time Data Pipeline
*Tên đầy đủ: "Modern Data Platform – Bài 8: CDC Architecture – Từ Transaction Log đến Near-Real-Time Data Pipeline" · Subtitle: Designing Reliable Change Data Capture, Event Streaming and Data Synchronization at Enterprise Scale · Đăng 08/10/2026 · 7 bảng dạng ảnh, đã đọc hết.*

Mục lục (H2): 1. CDC là gì và tại sao Incremental Load chưa đủ? | 2. Các phương pháp CDC và lý do Log-Based CDC thường được lựa chọn | 3. Oracle CDC: Redo Log, SCN và Transaction Consistency | 4. Initial Snapshot và CDC: bài toán đồng bộ dữ liệu ban đầu | 5. CDC Offset, Kafka Offset và Consumer Checkpoint: ba loại tiến độ khác nhau | 6. Event Ordering, Duplicate và Idempotency trong hệ thống phân tán | 7. CDC Failure Recovery: điều gì xảy ra khi hệ thống gặp sự cố? | 8. Near-Real-Time Architecture: đo latency như thế nào? | 9. Architecture Decision: khi nào cần Kafka, khi nào không? | 10. Case Study: thiết kế CDC từ Oracle/Tibero đến Enterprise Data Platform | Kết luận: (H4: CDC là bài toán về consistency và reliability, không chỉ về latency)

**1. Bối cảnh & vấn đề mở đầu**
- Bài nhắc lại kết luận của Bài 7: chọn cơ chế ingestion phù hợp, không cần công nghệ phức tạp nhất. Sau đó tác giả nêu tình huống mà Incremental Load truyền thống bắt đầu lộ giới hạn.
- Oracle Core của công ty chứng khoán có các bảng CUSTOMER, ACCOUNT, ORDERS, TRANSACTIONS, CASH_BALANCE, POSITION, MARGIN. Trong giờ giao dịch, dữ liệu thay đổi liên tục:
  - INSERT vào ORDERS;
  - UPDATE ORDERS 1001 sang MATCHED;
  - trừ 10.000.000 khỏi CASH_BALANCE của tài khoản A001.
- Yêu cầu business:
  - Dashboard cập nhật trong vài giây hoặc vài phút.
  - Risk Management theo dõi thay đổi của position và margin.
  - Nhận biết cả INSERT, UPDATE và DELETE.
  - Không bỏ sót giao dịch khi pipeline gặp sự cố.
  - Hạn chế truy vấn các bảng lớn trên Oracle production.
- Polling `UPDATED_AT > :last_watermark` vài giây một lần sẽ gặp vấn đề về latency, tải truy vấn, record bị xóa và consistency.
- CDC không chỉ là bật connector rồi đẩy dữ liệu vào Kafka. Một hệ thống CDC production phải giải quyết cùng lúc 9 vấn đề: Change Capture, Transaction Consistency, Initial Snapshot, Event Ordering, Duplicate Delivery, Offset Management, Schema Evolution, Failure Recovery, End-to-End Latency.

**2. Luận điểm cốt lõi**
- CDC là bài toán **consistency và reliability**, không chỉ là bài toán latency.
- CDC, Kafka và Streaming có thể kết hợp nhưng không thay thế nhau:
  - CDC: capture thay đổi.
  - Kafka: truyền tải, lưu giữ và phân phối event.
  - Streaming: xử lý liên tục.
- Kiến trúc CDC tốt phải bảo đảm thay đổi đã commit được capture, truyền tải, áp dụng và phục hồi theo đúng cam kết consistency, completeness và latency mà business cần.
- Chỉ thêm thành phần khi nó giải quyết một yêu cầu cụ thể.

**3. Khái niệm chính**
- **CDC:** tập hợp kỹ thuật phát hiện và ghi nhận thay đổi (INSERT/UPDATE/DELETE) của source rồi cung cấp cho downstream.
- **State Synchronization và Change History:**
  - State Synchronization giữ trạng thái hiện tại ở đích. Ví dụ: Power BI chỉ cần trạng thái cuối của lệnh.
  - Change History lưu chuỗi thay đổi. Ví dụ: đo thời gian từ NEW sang MATCHED.
  - Một pipeline CDC có thể phục vụ cả hai, nhưng lưu trữ và xử lý downstream phải được thiết kế tương ứng.
- **CDC ≠ Streaming:** CDC là cơ chế phát hiện thay đổi; Streaming là mô hình truyền tải hoặc xử lý liên tục.
- **Ba nhóm phương pháp:** timestamp-based polling (thực chất là incremental polling), trigger-based CDC, log-based CDC.
- **Redo log / archived redo log:** Oracle ghi thay đổi vào redo stream để phục vụ recovery; công cụ capture tương thích có thể khai thác lại.
- **SCN (System Change Number):**
  - Biểu thị thứ tự logic của thay đổi và là mốc capture hoặc mốc nhất quán.
  - Không phải định danh duy nhất của mọi event.
  - Connector có thể phải kết hợp SCN với transaction identifier, vị trí log và metadata khác.
- **Commit/transaction boundary** và ba tầng consistency:
  - Source transaction consistency: source commit thay đổi như thế nào.
  - CDC delivery consistency: connector capture và phát thay đổi theo semantics nào.
  - Target consistency: đích apply và publish thay đổi ra sao.
- **Supplemental logging:**
  - Bổ sung thông tin nhận diện vào redo stream. Redo mặc định không nhất thiết có đủ khóa và before-image mà công cụ replication cần.
  - Nhờ đó có thể apply UPDATE sang DB khác mà không phải dựa vào `ROWID` của source.
  - Bật phạm vi rộng sẽ làm tăng lượng redo.
- **Initial snapshot:** đồng bộ trạng thái ban đầu; cách làm đúng là lấy consistent snapshot tại SCN S0.
- **Ba loại tiến độ:** source log position, Kafka offset, consumer checkpoint.
- **Duplicate delivery và idempotency:** idempotency không đồng nghĩa với dedup theo primary key.
- **Exactly-once và at-least-once.**
- **RPO/RTO, Recovery Matrix, resnapshot, reconciliation, runbook.**
- **End-to-end latency** = Capture + Transport + Ingestion + Processing + Serving.
- **Freshness SLA:** gồm target, percentile và điểm bắt đầu/kết thúc đo.
- **Mirroring:** phương án direct CDC vào Lakehouse. Fabric Mirroring for Oracle dùng Oracle LogMiner để theo dõi thay đổi.

**4. Kiến trúc, pattern & quy trình**
- **Hai cách dùng CDC:**
  - `Database → CDC → Event Streaming → Stream Processing`
  - `Database → CDC → Change Storage → Micro-batch Processing`
  - Dùng CDC không tự biến cả platform thành real-time.
- **Trigger-based:** `Application → Source Table → Database Trigger → Change Table → CDC Consumer`.
- **Log-based:** `Application Transaction → Database → Transaction Log → CDC Connector → Change Events`.
- **Initial sync hai giai đoạn:** `Source DB → {Initial Snapshot → Baseline Dataset} + {Change Log → CDC Events} → Consistent Target`. Cách nối đúng: `SCN = S0 → Consistent Snapshot → Initial Data → Apply CDC from S0 → Current State`.
- **Chuỗi tiến độ:** `Oracle (SCN/Log Position) → CDC Connector → Kafka (Topic/Partition/Offset) → Lakehouse Consumer (Processing Checkpoint) → Bronze/Silver`.
- **Chuỗi latency:** `Source Commit → CDC Capture → Kafka Transport → Lakehouse Ingestion → Silver Processing → Gold Publication → BI/Application`.
- **Pattern tin cậy được khuyến nghị:** `At-least-once Delivery + Idempotent Processing + Durable Checkpoint + Replay Capability`.
- **Ba kiến trúc truyền tải:**

| Kiến trúc | Luồng | Ưu điểm | Hạn chế / phù hợp |
|---|---|---|---|
| A – Direct CDC to Lakehouse | `Oracle/Supported Source → CDC/Mirroring → Lakehouse → Silver/Gold` | Ít thành phần trung gian; vận hành đơn giản nếu nền tảng hỗ trợ; hợp khi chủ yếu có một target; tận dụng quản lý tích hợp | Phụ thuộc connector và dịch vụ; replay/fan-out tùy giải pháp; kém linh hoạt khi nhiều consumer cần dùng chung change stream |
| B – CDC + Kafka + Lakehouse | `Oracle/Tibero → CDC Connector → Kafka → {Lakehouse, Operational Analytics, Other Consumers}` | Tách producer khỏi consumer; nhiều consumer độc lập; buffer khi downstream chậm; replay trong retention; hợp event-driven quy mô lớn | Nhiều thành phần hơn; phải quản lý cluster, partition, retention, consumer lag, event schema và compatibility; phải thiết kế checkpoint, replay, ordering xuyên suốt |
| C – CDC + Micro-batch | `Oracle/Tibero → CDC Connector → Change Storage → Micro-batch Processing → Silver/Gold` | Tách capture (liên tục) khỏi processing (từng batch nhỏ) | Hợp khi cần dữ liệu theo phút nhưng không cần xử lý từng event ngay |

- **Kiến trúc logic của case study:** `SOURCE SYSTEMS (Oracle, Tibero, PostgreSQL) → INGESTION LAYER (Supported CDC/Incremental Readers; Snapshot/Log Position/Watermark) → EVENT TRANSPORT (Kafka: Topics/Retention/Replay) → LAKEHOUSE INGESTION (Event Decode/Checkpoint/Commit) → BRONZE (Source-Aligned Data/Change Events) → SILVER (Apply Changes/Merge/Conform) → GOLD (Trading/Risk/Customer Analytics) → Power BI | Risk APIs`. Mỗi nhánh source phải có connector thực sự được hỗ trợ trước khi triển khai.

**5. Framework ra quyết định & so sánh**

*So sánh ba phương pháp phát hiện thay đổi (mục 2)*

| Phương pháp | Ưu điểm | Hạn chế |
|---|---|---|
| Timestamp-based polling | Đơn giản, dễ triển khai | Cần timestamp đáng tin cậy; không tự capture hard delete; có thể mất trạng thái trung gian; phải truy vấn source theo chu kỳ; phải xử lý commit muộn và dữ liệu đến trễ |
| Trigger-based | Ghi nhận được thông tin nghiệp vụ rất cụ thể | Tăng công việc trong lúc ghi, có thể ảnh hưởng transaction latency, làm source phức tạp hơn; cần đánh giá kỹ với Core Trading có transaction rate cao |
| Log-based | Giảm polling trên bảng lớn; thông tin thay đổi có cấu trúc hơn | Vẫn tiêu tốn CPU, I/O, network; có thể buộc DB ghi thêm thông tin vào log (với Oracle là supplemental logging). CDC không loại bỏ chi phí xử lý mà chuyển chi phí sang capture và xử lý dòng thay đổi |

*Ảnh 1: Cơ chế log theo database*

| Database | Cơ chế log |
|---|---|
| Oracle | Redo Log / Archived Redo Log |
| PostgreSQL | WAL |
| MySQL | Binary Log |
| SQL Server | Transaction Log và các cơ chế CDC liên quan |
| Tibero | Cần xác minh cơ chế và connector được hỗ trợ theo phiên bản |

*Ba loại tiến độ (mục 5)*

Một Oracle transaction có thể tạo nhiều event nằm ở nhiều topic hoặc partition, nên không thể suy SCN từ Kafka offset hay ngược lại.

| Loại tiến độ | Trả lời câu hỏi | Ví dụ |
|---|---|---|
| Source log position | Connector đã capture tới đâu trong transaction log? | SCN 500900 |
| Kafka offset | Consumer đã đọc hoặc xác nhận xử lý tới đâu trong partition? | Topic `oracle.orders`, partition 0, offset 100–103 |
| Consumer checkpoint | Event nào đã được áp dụng an toàn vào target? | Batch 2001, partition 0, processed through offset 102, target commit SUCCESS |

*Ảnh 2: Các khái niệm định danh, giúp idempotency không loại bỏ nhầm event hợp lệ*

| Khái niệm | Mục đích |
|---|---|
| Business key | Xác định record nghiệp vụ |
| Event identity | Xác định một event cụ thể |
| Source ordering metadata | Xác định thứ tự thay đổi |
| Consumer checkpoint | Xác định tiến độ xử lý an toàn |

*Ảnh 3: Recovery Matrix*

| Failure | Rủi ro | Recovery strategy |
|---|---|---|
| CDC connector crash | Capture bị gián đoạn | Resume từ source position nếu log còn |
| Source log expired | Không thể đọc tiếp thay đổi cũ | Resnapshot/reconciliation theo quy trình |
| Kafka broker failure | Event transport gián đoạn | Phục hồi theo cấu hình replication và durability |
| Consumer crash | Target bị trễ | Resume từ checkpoint, xử lý replay |
| Target commit failure | Dữ liệu ghi dở dang | Retry hoặc rollback theo transaction semantics |
| Schema incompatibility | Consumer không xử lý được event | Dừng hoặc cách ly luồng lỗi, cập nhật mapping và replay |
| Extended consumer lag | Nguy cơ vượt retention | Scale, xử lý backlog hoặc recovery theo kế hoạch |

*Ảnh 4: Ví dụ phân rã latency (giả định, không phải benchmark)*

| Thành phần | Latency |
|---|---|
| CDC Capture | 2 giây |
| Kafka Transport | 1 giây |
| Lakehouse Ingestion | 5 giây |
| Silver Processing | 10 giây |
| Gold Publication | 2 giây |
| **Tổng** | **20 giây** |

Nếu Silver chỉ chạy theo lịch mỗi 5 phút, end-to-end latency sẽ lớn hơn đáng kể dù CDC capture rất nhanh.

*Ảnh 5: So sánh ba kiến trúc*

| Tiêu chí | Direct CDC | CDC + Kafka | CDC + Micro-batch |
|---|---|---|---|
| Độ phức tạp | Thường thấp hơn | Cao hơn | Trung bình, tùy nền tảng |
| Nhiều consumer | Tùy connector | Phù hợp | Tùy storage/architecture |
| Buffering | Tùy giải pháp | Có, theo cấu hình Kafka | Theo change storage |
| Replay | Tùy giải pháp | Theo retention | Theo dữ liệu đã lưu |
| Latency | Có thể thấp | Có thể thấp | Phụ thuộc chu kỳ xử lý |
| Vận hành | Ít thành phần hơn | Nhiều thành phần hơn | Phụ thuộc orchestration |
| Phù hợp | Đồng bộ tập trung | Multi-consumer/event-driven | Analytics theo phút |

- **Khi nào cần Kafka:**
  - Nếu chỉ cần đồng bộ vài bảng Oracle sang Lakehouse cho BI mỗi 5 phút, có thể không cần cả một Kafka cluster.
  - Nếu cùng một change stream phải phục vụ Risk Engine, Operational Analytics và nhiều ứng dụng khác, Kafka mang lại lợi ích kiến trúc đáng kể.
- **Mức consistency chấp nhận được:** sai lệch tạm thời giữa ORDERS và CASH_BALANCE có thể chấp nhận với dashboard tổng hợp, nhưng có thể không chấp nhận được với Risk Analytics hoặc đối soát giao dịch.
- **Exactly-once:**
  - Một số hệ thống hỗ trợ exactly-once trong phạm vi nhất định.
  - Dù Kafka có transactional processing, sink ghi vào Lakehouse vẫn cần cơ chế tương thích để commit dữ liệu và checkpoint an toàn.
  - Vì vậy nên chọn at-least-once + idempotent + durable checkpoint + replay. Mục tiêu là trạng thái đúng sau xử lý và phục hồi, không phải nhãn exactly-once.


**6. Best practices / nguyên tắc thiết kế**
- Xác định cần state sync, change history hay cả hai, rồi thiết kế lưu trữ downstream tương ứng.
- Hiểu ranh giới transaction. Nếu business cần consistency theo transaction, target phải có cơ chế phối hợp hoặc publish theo transaction boundary.
- Lấy metadata thứ tự từ những trường thực sự có semantics ordering trong connector đã chọn.
- DBA và Data Architect cùng chọn phạm vi supplemental logging; không bật toàn bộ thông tin cho mọi bảng.
- Lấy snapshot tại một vị trí nhất quán trong log (SCN S0) rồi chạy CDC tiếp từ đúng vị trí đó. Xác minh locking, snapshot mode, cách xử lý long-running transaction và recovery theo phiên bản connector.
- Quản lý và giám sát riêng ba loại tiến độ. Thiết kế việc ghi dữ liệu và cập nhật checkpoint sao cho replay không làm sai trạng thái đích.
- Route các event cùng key (ví dụ `ORDER_ID`) nhất quán vào cùng một partition, hoặc có cơ chế xử lý ordering ở downstream. Lưu ý: cách này không giải quyết consistency của transaction nhiều bảng.
- Định nghĩa RPO/RTO cho từng luồng dữ liệu. Bảo đảm log retention, event retention, checkpoint durability, capacity và runbook.
- Định nghĩa Freshness SLA bằng percentile và điểm đo rõ ràng. Lưu ý đồng hồ giữa các hệ thống có thể lệch nhau.
- Giám sát 8 chỉ số (mục 10) để phân biệt connector chậm, broker tồn đọng hay downstream không theo kịp.
- Chỉ thêm thành phần khi giải quyết yêu cầu cụ thể. Chọn CDC theo semantics của bảng, không theo tên bảng.
- Thiết kế và kiểm thử recovery trước khi go-live. Sau restart phải xác minh target đã xử lý đủ event và không có trạng thái sai, không chỉ kiểm tra service đã chạy lại.
- Đưa Fabric Mirroring for Oracle vào danh sách đánh giá trước khi tự dựng Debezium + Kafka, và đối chiếu các giới hạn đã công bố.
- Nghiệm thu bằng load test, failure test và reconciliation thực tế, không dựa vào thông số quảng cáo.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Polling `UPDATED_AT` vài giây một lần trên bảng lớn của Oracle production.
- Mặc định `CDC = Debezium + Kafka`, hoặc đồng nhất CDC với real-time/Streaming.
- Nghĩ rằng CDC không tạo tải lên source.
- Dùng trigger-based CDC trên Core Trading có transaction rate cao mà không đánh giá kỹ.
- Coi một SCN đơn lẻ là ID duy nhất của event, hoặc giả định mọi connector biểu diễn thứ tự giống nhau.
- Nghĩ rằng gửi event qua nhiều topic/partition thì consumer vẫn thấy trọn một transaction cùng lúc.
- Bật supplemental logging tràn lan, làm tăng redo.
- Chụp snapshot từ 10:00 đến 10:05 rồi mới đọc log từ 10:06, làm mất UPDATE của order 1001 lúc 10:01 và INSERT của order 1002 lúc 10:02.
- Tự ghép snapshot với CDC mà không kiểm chứng; để snapshot kéo dài trong khi archived log cần thiết đã bị xóa.
- Chỉ giám sát connector, nên tưởng hệ thống ổn trong khi target đang trễ.
- Suy SCN từ Kafka offset hoặc ngược lại.
- Dedup theo `ORDER_ID`, làm mất các event hợp lệ.
- Áp dụng event sai thứ tự E1 → E3 → E2, khiến đích là MATCHED trong khi source đã COMPLETED.
- Tuyên bố exactly-once cho cả chuỗi Oracle → Kafka → Lakehouse.
- Tăng log position để nhảy qua đoạn log bị thiếu khi chưa đánh giá tác động mất dữ liệu.
- Để consumer dừng lâu hơn Kafka retention.
- Đánh giá CDC bằng việc connector đang chạy hoặc Kafka đang nhận event.
- Nói hệ thống hỗ trợ near-real-time mà không có SLA đo được.
- Giả định Oracle Mirroring của Fabric cũng hỗ trợ Tibero.
- Giả định mọi bảng trong cùng một DB có cùng yêu cầu consistency.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **Bảng ORDERS ban đầu** (bảng bị flatten trong file, đã tái dựng): ORDER_ID 1001 | STATUS NEW | QTY 1000.
  - Trong 1 giây: T1 INSERT (NEW) → T2 UPDATE (MATCHED) → T3 UPDATE (COMPLETED).
  - Đọc trạng thái sau T3 chỉ thấy COMPLETED, không biết các trạng thái đã đi qua.
- **Transaction A** là một đơn vị nghiệp vụ: UPDATE ORDERS 1001 sang MATCHED, trừ 10.000.000 khỏi CASH_BALANCE của A001, rồi COMMIT.
- **SCN minh họa:** SCN 500100 chứa Transaction A; SCN 500200 chứa Transaction B (INSERT TRANSACTION + COMMIT).
- **Initial snapshot với ORDERS 100.000.000 records:** snapshot bắt đầu 10:00 → UPDATE 1001 lúc 10:01 → INSERT 1002 lúc 10:02 → snapshot xong 10:05 → CDC bắt đầu 10:06. Kết quả là có khoảng trống.
- **Lag:** CDC đã capture tới SCN 500900, Kafka nhận tới offset 1200, Lakehouse mới xử lý tới offset 1150. Dữ liệu đã qua connector nhưng target đang trễ.
- **Ghi xong nhưng chưa checkpoint:** consumer ghi xong offset 1151–1200 rồi chết trước khi commit checkpoint, nên khi restart sẽ xử lý lại các event này.
- **Ordering:** thứ tự đúng là E1 NEW → E2 MATCHED → E3 COMPLETED.
- **Duplicate:** nhận E2 → apply E2 → crash trước checkpoint → restart → nhận lại E2.
- **Event chuẩn hóa (khái niệm):** source ORACLE_CORE, table ORDERS, operation UPDATE, business_key ORDER_ID 1001, source_position {scn 500900, sequence connector-specific}, after STATUS COMPLETED. Đây không phải payload chuẩn của Oracle hay Debezium.
- **Ba tình huống sự cố:**
  - Connector chạy lúc 10:00, dừng lúc 10:05, khởi động lại lúc 12:00. Nếu log còn và checkpoint hợp lệ thì resume; nếu không thì resnapshot hoặc reconciliation.
  - Kafka vẫn chạy nhưng consumer dừng. Kafka làm buffer trong giới hạn retention.
  - Target commit thành công nhưng checkpoint thất bại. Khi restart sẽ replay, nên cần idempotency.
- **RPO/RTO mẫu:** RPO là không bỏ sót thay đổi đã commit; RTO là khôi phục pipeline trong 30 phút. Đây là mục tiêu thiết kế, không phải đặc tính mặc định của CDC.
- **Freshness SLA mẫu:** data_product `trading_orders`, target 30 giây, percentile p95, đo từ `source_commit` đến `consumer_visible`.
- **Case study:** nguồn gồm Oracle Core, Tibero, PostgreSQL và Market Data API.

*Ảnh 6: Yêu cầu freshness của case study (giả định)*

| Data domain | Freshness requirement |
|---|---|
| Order | 10–30 giây |
| Transaction | 30–60 giây |
| Position | 1–5 phút |
| Customer | 15 phút |
| Reference Data | Hằng ngày |

Phân loại chiến lược trong case study:
- ORDER → CDC.
- TRANSACTION → CDC hoặc Incremental.
- POSITION → CDC, Snapshot hoặc Incremental, tùy semantics: trạng thái hiện tại, snapshot theo thời điểm hay sự kiện biến động.
- CUSTOMER → Incremental hoặc CDC.
- REFERENCE DATA → Full Load.

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle:** redo log/archived redo log, SCN, supplemental logging, ROWID.
- **Oracle LogMiner:** đọc thay đổi từ redo (tài liệu tham khảo: Oracle Database 19c – LogMiner).
- **Các DB khác:** PostgreSQL (WAL), MySQL (Binary Log), SQL Server (Transaction Log và cơ chế CDC liên quan). Với Tibero phải xác minh cơ chế và connector theo phiên bản.
- **Debezium Oracle Connector:** chụp snapshot dựa trên SCN rồi chuyển sang streaming; chi tiết phụ thuộc phiên bản.
- **Kafka:** truyền tải, lưu giữ và phân phối event; buffer khi downstream chậm; replay trong phạm vi retention; bảo đảm thứ tự trong từng partition, nhưng không bảo đảm thứ tự toàn cục giữa các partition.
- **Lakehouse:**
  - Bronze: dữ liệu source-aligned và change event.
  - Silver: apply, merge, conform.
  - Gold: Trading/Risk/Customer Analytics.
- **Microsoft Fabric Mirroring for Oracle:** dùng LogMiner. Khả năng dùng thực tế phụ thuộc môi trường, phiên bản, gateway và giới hạn hiện hành. Tài liệu tham khảo: Mirroring Oracle Databases, Oracle Mirroring Limitations, Mirroring Overview.
- **Consumer:** Power BI, Risk APIs, Risk Engine, Operational Analytics.

**10. Checklist / câu hỏi thiết kế**
- Chín vấn đề của CDC production (mục 1).
- Bảy điểm cần đánh giá khi snapshot bảng rất lớn (hàng trăm triệu đến hàng tỷ records, có thể mất hàng giờ):
  1. Khả năng đọc snapshot nhất quán.
  2. Tải lên source.
  3. Parallel extraction và giới hạn concurrency.
  4. Network bandwidth.
  5. Thời gian snapshot.
  6. Khả năng khôi phục khi snapshot lỗi.
  7. Log retention trong suốt thời gian snapshot.
- Tám chỉ số giám sát: source capture lag, Kafka consumer lag, oldest unprocessed event age, checkpoint progress, target publication delay, error/retry rate, snapshot progress, log retention headroom.
- Bảy bước của case study:
  1. **Phân loại source và ingestion strategy.**
  2. **Đánh giá khả năng capture.** Với Oracle: log-based CDC hoặc mirroring tương thích. Với Tibero: xác minh riêng connector, phiên bản, quyền đọc log, khả năng capture I/U/D; nếu không có thì dùng incremental extraction hoặc cơ chế tích hợp khác.
  3. **Chọn kiến trúc truyền tải.** Có nhiều consumer và cần buffer thì dùng Kafka.
  4. **Xác định consistency model** bằng 5 câu hỏi:
     - Consumer cần trạng thái mới nhất hay toàn bộ lịch sử?
     - Có cần consistency theo transaction không?
     - Có chấp nhận trạng thái tạm thời lệch giữa các bảng không?
     - Khi nào dữ liệu được phép publish sang Gold?
     - Event đến muộn thì xử lý ra sao?
  5. **Thiết kế recovery trước go-live** với 10 kịch bản test:
     1. Restart CDC connector.
     2. Restart Kafka consumer.
     3. Target write failure.
     4. Duplicate event replay.
     5. Connector lag vượt ngưỡng.
     6. Kafka retention gần hết.
     7. Source log không còn khả dụng.
     8. Schema change.
     9. Initial snapshot failure.
     10. Source failover/role change.

     Mỗi kịch bản cần xác định Detection, Impact, Recovery Procedure, Data Reconciliation và Acceptance Criteria.
  6. **Tích hợp Microsoft Fabric.**
  7. **Xác định chỉ số nghiệm thu** (Ảnh 7).

*Ảnh 7: Tiêu chí nghiệm thu (minh họa)*

| Tiêu chí | Mục tiêu minh họa |
|---|---|
| Order freshness | p95 ≤ 30 giây |
| Transaction freshness | p95 ≤ 60 giây |
| Capture completeness | Không bỏ sót thay đổi đã commit trong phạm vi cam kết |
| Duplicate handling | Replay không làm sai trạng thái đích |
| Connector recovery | Resume từ checkpoint hợp lệ |
| Source impact | Trong ngưỡng tải được DBA phê duyệt |
| Schema change | Có quy trình phát hiện và xử lý |
| Data reconciliation | Có cơ chế kiểm tra source–target |

**11. Kết luận & key takeaways**
- CDC ≠ Kafka ≠ Streaming. Ba khái niệm lần lượt là capture thay đổi; truyền tải, lưu giữ và phân phối event; xử lý liên tục.
- Transaction consistency phải được thiết kế rõ ràng. Capture đúng từng event không tự bảo đảm target nhất quán giữa nhiều bảng hoặc nhiều consumer.
- Initial snapshot và CDC liên tục phải được phối hợp để không bỏ sót thay đổi xảy ra trong lúc snapshot.
- Source position, Kafka offset và consumer checkpoint phải được quản lý độc lập. Quản lý sai sẽ dẫn đến duplicate, mất dữ liệu hoặc sai trạng thái đích.
- Reliability quan trọng không kém latency. Pipeline cập nhật trong 2 giây nhưng có thể bỏ sót dữ liệu khi restart chưa chắc tốt hơn pipeline 30 giây có phục hồi và reconciliation đáng tin cậy.
- Không có kiến trúc CDC chung cho mọi doanh nghiệp. Direct CDC, CDC qua Kafka và CDC kết hợp micro-batch đều có trade-off về latency, consistency, chi phí và vận hành.
- Theo tác giả, đây chính là khác biệt giữa triển khai một CDC connector và thiết kế hệ thống Data Synchronization ở quy mô enterprise.
- Hai trích dẫn tiêu biểu:
  - «CDC là bài toán về consistency và reliability, không chỉ về latency»
  - «thêm thành phần khi nó giải quyết một yêu cầu cụ thể, không phải vì nó xuất hiện trong reference architecture phổ biến.»

**12. Liên kết với các bài khác**
- **Bài 7:** Bài 8 tiếp nối trực tiếp, mở rộng mục 7 của Bài 7 (vốn đã hứa tách CDC thành bài riêng). Khái niệm checkpoint của Bài 7 được mở rộng thành ba loại tiến độ. Case study đẩy yêu cầu freshness xuống mức giây (Order 10–30 giây), thay vì 5–10 phút như Bài 7, nên CDC mới trở nên cần thiết.
- **Bài 4 (Medallion):** dùng lại Bronze/Silver/Gold.
- **Microsoft Fabric:** tiếp nối mục "Microsoft Fabric nằm ở đâu?" của Bài 7, nay cụ thể hóa bằng Mirroring Oracle.
- **Bài 15 (Data Observability):** Bài 8 chỉ bàn những gì cần thiết kế để CDC vận hành và phục hồi đúng. Bài 15 sẽ đi sâu vào observability và tối ưu vận hành toàn platform.
- **Bài tiếp theo:** chuyển từ Data Ingestion Architecture sang **Analytical Data Modeling & Data Product Design**, tức là xây mô hình dữ liệu cho analytics mà không biến Gold thành tập bảng tổng hợp thiếu nhất quán. [Ghi chú: bài không ghi số, khả năng cao là Bài 9.]

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **Yêu cầu và semantics trước, công nghệ sau.** Chọn chiến lược theo từng bảng hoặc data domain (volume, change rate, update/delete, khả năng source, SLA). Latency business không quyết định kiến trúc xử lý; CDC ≠ Kafka ≠ Streaming. Chỉ thêm thành phần khi nó giải quyết yêu cầu cụ thể. Không chọn theo tên bảng hay xu hướng; POSITION là ví dụ lặp lại ở cả hai bài.
- **Tiến độ phải đúng nghĩa.** Bài 7 dùng watermark, extraction boundary và checkpoint; Bài 8 mở rộng thành source log position, Kafka offset và consumer checkpoint. Không tiến checkpoint trước khi ghi bền vững, mỗi mốc phải biết rõ nó đại diện cho điều gì, và phải giám sát từng chặng.
- **Thiết kế cho sự cố thay vì tin vào exactly-once.** Kết hợp at-least-once, idempotency, replay và durable checkpoint. Dedup đúng cấp (business key khác event identity). Retention của redo/archived log và Kafka là giới hạn sống còn. Cần RPO/RTO, Recovery Matrix, failure test trước go-live và reconciliation.
- **Consistency là quyết định kiến trúc.** Gồm snapshot consistency, transaction boundary (ORDER/TRANSACTION, ORDERS/CASH_BALANCE) và phối hợp initial snapshot với CDC (SCN S0). Phải nói rõ mức consistency business chấp nhận, không suy ra từ việc các bảng được đọc gần nhau về thời gian.
- **Đo end-to-end và phân biệt các trạng thái "xong".** Freshness tính từ source commit đến lúc consumer thấy được (SLA theo p95). Lịch chạy không phải là freshness, và ingestion completed không phải là data product ready.
- **Xác minh năng lực thực tế.** Oracle và Tibero được hỗ trợ khác nhau. Microsoft Fabric (Data Factory, Lakehouse/OneLake, Mirroring Oracle qua LogMiner) chỉ là bộ công cụ, không quyết định thay kiến trúc sư. Nghiệm thu bằng load test, failure test và reconciliation, không dựa vào thông số quảng cáo.


---

## Bài 9: Modern Data Platform – Bài 9: Analytical Data Modeling – Từ Source Data đến Business-Ready Data Model
*Subtitle: Designing Fact, Dimension and Analytical Models for Enterprise Data Platforms · Đăng 2026-10-09 · 8 hình/bảng (đã đọc hết)*

Mục lục (H2): 1. Từ Operational Data đến Analytical Data: vì sao không nên dùng trực tiếp OLTP Schema? | 2. Analytical Data Modeling: Dimensional Modeling và các lựa chọn kiến trúc | 3. Grain: quyết định quan trọng nhất trước khi thiết kế Fact Table | 4. Fact Table Design: Transaction, Periodic Snapshot và Accumulating Snapshot | 5. Dimension Design: Business Key, Surrogate Key và Slowly Changing Dimension | 6. Case Study: xây dựng Trading Analytics Data Model từ Oracle/Tibero | 7. Incremental Data Modeling: xử lý CDC, Late-Arriving Data và Backfill | 8. Measure Design: Additive, Semi-Additive và Non-Additive | 9. Semantic Model: cầu nối giữa Data Model và Business Metrics | 10. Architecture Decisions: thiết kế Analytical Data Model ở quy mô Enterprise | Kết luận: Data Modeling là nơi dữ liệu bắt đầu mang ý nghĩa business

**1. Bối cảnh & vấn đề mở đầu**
- Bài 7–8 đã giải quyết khâu đưa dữ liệu vào platform: Full Load, Incremental Load, CDC, capture INSERT/UPDATE/DELETE, watermark, checkpoint và recovery. Câu hỏi tiếp theo: dữ liệu đã được đồng bộ thành công, nhưng đã sẵn sàng cho business dùng chưa?
- Công ty chứng khoán có các nguồn Oracle Core, Tibero, PostgreSQL, CRM và Market Data. Silver đã có `customer, account, orders, order_matches, transactions, cash_balance, position, market_price`. Business cần các báo cáo: giá trị giao dịch theo ngày/khách hàng/chi nhánh, doanh thu môi giới theo nhóm khách hàng, tỷ lệ lệnh khớp/hủy, tổng tài sản khách hàng, Risk Exposure, Customer 360.
- Khi để từng nhóm BI tự JOIN bảng Silver, cùng chỉ số Trading Value lại ra ba con số: Dashboard A = 120 tỷ, B = 118 tỷ, C = 123 tỷ.
  - A tính theo ngày đặt lệnh.
  - B tính theo ngày khớp lệnh.
  - C tính cả giao dịch bị điều chỉnh hoặc loại trừ theo quy tắc khác.
- Dữ liệu ở cả ba dashboard đều hợp lệ. Vấn đề là **business definitions không thống nhất**.

**2. Luận điểm cốt lõi**
Analytical Data Modeling không chỉ là sắp xếp lại bảng. Đó là việc biến dữ liệu kỹ thuật thành mô hình có ý nghĩa nghiệp vụ, nhất quán và tái sử dụng được. Các quyết định nền tảng gồm grain, loại Fact, key và lịch sử của Dimension, aggregation semantics của measure. Những quyết định này phải được thiết kế có chủ đích và đi cùng ingestion (CDC, late data, backfill). Chúng là nền móng cho Semantic Layer và Data Product.

**3. Khái niệm chính**
- **OLTP vs OLAP:** hai mục tiêu thiết kế khác nhau. Schema nguồn phản ánh cách ứng dụng vận hành; analytics phải phản ánh cách business đặt câu hỏi.
- **Analytical Data Modeling:** thiết kế cấu trúc dữ liệu để phục vụ phân tích, tổng hợp, truy vấn và khai thác thông tin.
- **Dimensional Modeling (Kimball):** tách dữ liệu thành hai nhóm.
  - **Fact:** ghi nhận sự kiện, hoạt động hoặc trạng thái cần phân tích.
  - **Dimension:** cung cấp ngữ cảnh (ai, ở đâu, khi nào, thuộc nhóm nào, đặc điểm gì).
- **Star Schema:** Fact ở trung tâm, nối trực tiếp với các Dimension.
- **Snowflake Schema:** chuẩn hóa một số Dimension thành chuỗi bảng, ví dụ `DIM_ACCOUNT → DIM_BRANCH → DIM_REGION`.
- **Grain:** mô tả chính xác một dòng trong Fact đại diện cho điều gì.
- **Fan-out:** số dòng bị nhân lên khi JOIN hai bảng khác grain, dẫn đến double counting.
- **Business key và Surrogate key:**
  - Business key là định danh của hệ nguồn, ví dụ `CUSTOMER_ID = C001`.
  - Surrogate key là định danh riêng của Dimension, ví dụ `CUSTOMER_KEY = 10001`. Nó tách Dimension khỏi định danh hệ nguồn.
- **SCD Type 1:** ghi đè giá trị cũ.
- **SCD Type 2:** lưu từng phiên bản với `VALID_FROM/VALID_TO`. `VALID_TO` là mốc kết thúc *không bao gồm* trong khoảng hiệu lực.
- **Business effective time vs System/capture time:** CDC chỉ cho biết thời điểm hoặc thứ tự thay đổi theo cơ chế của nguồn. Nó không tự cho biết thời điểm thay đổi có hiệu lực về nghiệp vụ.
- **Conformed Dimension:** Dimension được quản lý và dùng nhất quán giữa nhiều Fact hoặc business process.
- **Các tình huống dữ liệu trễ và xử lý lại:**
  - Late-Arriving Fact và Late-Arriving Dimension (xử lý bằng unknown member hoặc inferred member).
  - Historical Restatement: điều chỉnh số liệu của kỳ đã báo cáo.
  - Backfill: xử lý lại một khoảng thời gian hoặc phạm vi đã xử lý trước đó.
- **Additive / Semi-additive / Non-additive measure:** ba cách tổng hợp khác nhau (chi tiết ở mục 5).
- **Semantic Model:** lớp giúp consumer hiểu và dùng dữ liệu bằng ngôn ngữ business.

**4. Kiến trúc, pattern & quy trình**
- **Luồng cơ bản:** `Operational Systems → Bronze → Silver → Analytical Data Model → Business Consumption`. Silver chuẩn hóa và tích hợp; Analytical Model tổ chức dữ liệu theo cách business phân tích.
- **Star Schema mẫu:** `FACT_TRADE` (MATCHED_QUANTITY, MATCHED_PRICE, MATCHED_VALUE, COMMISSION) nối với DIM_CUSTOMER, DIM_DATE, DIM_SECURITY, DIM_ACCOUNT và Branch.
- **Accumulating Snapshot cho vòng đời lệnh:**
  - Luồng: `Order Created → Order Accepted → Partially Matched → Fully Matched / Canceled`.
  - Cột: ORDER_ID, CREATED_DATE_KEY, ACCEPTED_DATE_KEY, FIRST_MATCH_DATE_KEY, COMPLETED_DATE_KEY, CURRENT_STATUS.
  - Record được cập nhật khi quy trình tiến triển.
- **Xử lý CDC theo semantics của Fact:**
  - `CDC Events → Current State Model → Upsert/Delete`
  - `CDC Events → Event History Model → Append/Deduplicate`
- **Luồng có semantic:** `Source Systems → Bronze → Silver → Analytical Data Model → Semantic Model → BI / Analytics / Applications`.
- **Ranh giới trách nhiệm:** Data Model giữ `FACT_TRADE.MATCHED_VALUE`. Semantic Measure định nghĩa "Total Trading Value = SUM of eligible matched trade value".
- **Kiến trúc tổng thể 7 tầng:**
  - SOURCE SYSTEMS (Oracle/Tibero/PostgreSQL/APIs)
  - → INGESTION (Full/Incremental/CDC/Streaming)
  - → BRONZE (Raw/Source-Aligned)
  - → SILVER (Clean/Conform/Integrate)
  - → ANALYTICAL MODEL (Facts/Dimensions/Snapshots/History/Aggregates)
  - → SEMANTIC LAYER (Business Metrics/Relationships/Definitions/Access Rules)
  - → CONSUMPTION (Power BI/Analytics/APIs/AI)
- Analytical Model thường thuộc Gold hoặc curated serving layer. Theo tác giả, điều quan trọng là trách nhiệm được phân tách rõ, không phải tên layer.

**5. Framework ra quyết định & so sánh**

OLTP vs OLAP (Hình 1):

| Tiêu chí | OLTP | OLAP |
|---|---|---|
| Mục tiêu | Xử lý nghiệp vụ | Phân tích, ra quyết định |
| Workload | Nhiều giao dịch nhỏ | Truy vấn tổng hợp, scan dữ liệu lớn |
| Mô hình | Thường chuẩn hóa | Thường dimensional hoặc tối ưu cho analytics |
| Dữ liệu | Chủ yếu trạng thái nghiệp vụ | Hiện tại và lịch sử |
| Truy vấn | Theo khóa, cập nhật record | Theo thời gian, chiều phân tích, KPI |
| Tối ưu | Transaction latency và consistency | Scan, aggregation, concurrency, usability |

Tác giả lưu ý: điều này không có nghĩa OLTP luôn chuẩn hóa hay OLAP luôn denormalize. Khác biệt nằm ở mục tiêu thiết kế.

- **Star vs Snowflake:**
  - Star dễ hiểu, thuận tiện cho BI, giảm chuỗi JOIN, tái sử dụng Dimension giữa nhiều Fact.
  - Snowflake giảm dư thừa ở Dimension nhưng tăng độ phức tạp của JOIN và của mô hình tiêu thụ.
  - Không cái nào mặc định tốt hơn; tùy workload, engine và yêu cầu quản lý dữ liệu.
- **Các mô hình có thể cùng tồn tại:**
  - Dimensional cho BI/reporting.
  - Data Vault cho tích hợp, lưu lịch sử, audit.
  - Wide Table cho workload phân tích cụ thể.
  - Normalized Model cho dữ liệu dùng chung.
  - Aggregate Table cho truy vấn hiệu năng cao.
  - Feature Table cho ML.

Ba loại Fact (Hình 4):

| Loại Fact | Grain | Ví dụ |
|---|---|---|
| Transaction | Một sự kiện | Một lần khớp lệnh |
| Periodic Snapshot | Một đối tượng tại một kỳ | Số dư tài khoản cuối ngày |
| Accumulating Snapshot | Một instance của quy trình | Vòng đời xử lý một lệnh |

Platform thường phải kết hợp cả ba loại. Accumulating Snapshot chỉ giữ milestone hiện tại, nên nếu cần toàn bộ lịch sử trạng thái thì phải bổ sung event history hoặc transaction/event fact.

Workload → mô hình (Hình 8, mục "Không phải mọi bảng Gold đều cần Star Schema"):

| Workload | Mô hình có thể phù hợp |
|---|---|
| Trading BI | Dimensional Model |
| Customer 360 | Integrated Entity Model hoặc Dimensional Model |
| Risk Exposure | Snapshot Fact, analytical tables hoặc mô hình chuyên biệt |
| Machine Learning | Feature-oriented datasets |
| Regulatory Reporting | Reporting model theo yêu cầu nghiệp vụ |
| Ad-hoc exploration | Silver hoặc curated analytical datasets |

Loại measure (mục 8):

| Loại | Ví dụ | Cách tổng hợp |
|---|---|---|
| Additive | MATCHED_QUANTITY, MATCHED_VALUE, COMMISSION_AMOUNT | Cộng qua các chiều phù hợp, nhưng vẫn phải xử lý reversal, correction và phạm vi nghiệp vụ |
| Semi-additive | CASH_BALANCE, MARKET_VALUE, TOTAL_ASSET_VALUE | Cộng được qua các tài khoản tại cùng thời điểm, không cộng qua thời gian. Số dư cuối kỳ lấy snapshot của kỳ; số dư bình quân cần công thức riêng và quy tắc xử lý ngày thiếu dữ liệu |
| Non-additive | MATCH_RATE, AVERAGE_PRICE, MARGIN_RATIO | Tính lại từ numerator và denominator |

- **SCD1 vs SCD2:** SCD1 cho thuộc tính không cần phân tích lịch sử hoặc khi sửa dữ liệu sai. SCD2 khi cần phân tích theo thuộc tính có hiệu lực tại thời điểm lịch sử. Không phải thuộc tính nào cũng cần SCD2.
- **Late-Arriving Dimension, bốn phương án:**
  - Dùng tạm unknown member.
  - Tạo inferred member với thông tin tối thiểu.
  - Hoãn publish đến khi Dimension sẵn sàng.
  - Xử lý lại Fact sau khi Dimension xuất hiện.
  - Lựa chọn tùy yêu cầu completeness và consistency của Data Product.
- **Historical Restatement, ba câu hỏi phải trả lời:**
  - Có cập nhật lại báo cáo kỳ cũ không?
  - Có ghi adjustment vào kỳ hiện tại không?
  - Có lưu cả số đã công bố lẫn số sau điều chỉnh không?
  - Đây không chỉ là vấn đề kỹ thuật mà còn là quy tắc kế toán và reporting.
- **Conformed Dimension ở cấp enterprise:** các domain Trading, Risk và Customer cùng dùng thông tin khách hàng. Cần chuẩn hóa định danh và một số thuộc tính cốt lõi dùng chung, nhưng vẫn cho phép từng domain có mô hình chuyên biệt.
- **Performance & Cost:**
  - Yếu tố cần đánh giá: Fact Table Volume, Partitioning, Clustering, Data Skipping, Incremental Refresh, Aggregation Strategy, Query Concurrency, Storage Cost, Compute Cost.
  - Biện pháp: partition theo thời gian (nếu hợp với engine và query pattern), tối ưu data layout, incremental processing, aggregate tables cho một số workload, bớt JOIN thừa, tách mô hình theo workload.
  - Không nên tạo quá nhiều aggregate tables.

**6. Best practices / nguyên tắc thiết kế**
- **Chọn mô hình:**
  - Không sao chép nguyên trạng OLTP schema rồi mặc định đó là mô hình analytics.
  - Chọn mô hình từ business process, query pattern và mức tái sử dụng, không vì nó phổ biến.
  - Bắt đầu từ business process, không copy từng bảng nguồn sang Gold.
- **Thiết kế Fact:**
  - Xác định grain trước, rồi mới chọn Dimension và Measure.
  - Mỗi process có grain và Fact riêng; không gộp mọi thứ vào một Fact chỉ vì cùng liên quan đến giao dịch.
- **Thiết kế Dimension:**
  - Dùng surrogate key khi có nhiều nguồn, source key có thể trùng, cần lưu lịch sử hoặc nhiều phiên bản của cùng một entity.
  - Thiết kế lịch sử theo nhu cầu phân tích và quản trị dữ liệu; cần quy tắc riêng cho thay đổi có hiệu lực hồi tố.
  - Xác định branch attribution theo quy tắc nghiệp vụ tại thời điểm giao dịch, ví dụ đặt `BRANCH_KEY` trực tiếp trong Fact.
  - Thống nhất trước quy tắc với giao dịch bị hủy, sửa, điều chỉnh hoặc reversal.
- **Kết hợp với ingestion:**
  - Xử lý CDC theo grain và semantics của Fact.
  - Incremental modeling dựa vào tiến độ dữ liệu và khả năng nhận late-arriving records, không chỉ dựa vào ngày nghiệp vụ.
  - Backfill phải: không tạo duplicate ngoài ý muốn; không ghi đè dữ liệu mới bằng dữ liệu cũ; xử lý đúng Dimension lịch sử; giữ consistency giữa Fact và Aggregate; kiểm tra được trước khi publish.
  - Analytical Data Modeling và Data Ingestion phải được thiết kế cùng nhau.
- **Measure và Semantic Layer:**
  - Mỗi measure cần metadata: Measure Name, Business Definition, Grain, Aggregation Rule, Time Semantics, Applicable Dimensions, Exclusion Rules.
  - Phân định rõ logic nào chuẩn hóa ở tầng dữ liệu, logic nào đặt ở semantic layer.
- **Ownership & lifecycle của mô hình:**
  - Quản lý Model Owner, Business Definition, Source Lineage, Schema Version, Refresh SLA, Data Quality Expectations, Consumer Dependencies, Deprecation Policy.
  - Đánh giá downstream impact trước khi đổi schema, vì một thay đổi ở DIM_CUSTOMER có thể ảnh hưởng hàng chục Fact và dashboard.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- **Ở tầng tiêu thụ:**
  - Mỗi nhóm BI tự JOIN Silver và tự tính KPI, dẫn đến ba con số khác nhau cho một chỉ số.
  - Triển khai business definition riêng trong từng Power BI report.
  - Nghĩ rằng thêm semantic layer sẽ tự giải quyết được định nghĩa chưa thống nhất.
- **Ở Fact và grain:**
  - Tạo Fact trước khi có grain, khiến Fact lẫn nhiều loại sự kiện.
  - JOIN trực tiếp FACT_ORDER với FACT_TRADE gây fan-out: `SUM(ORDER_QUANTITY)` ra 3,000 thay vì 1,000.
- **Ở measure:**
  - Cộng semi-additive qua thời gian: 500M + 520M + 510M = 1.53 tỷ, hay 100 + 120 + 110 = 330 triệu, đều vô nghĩa.
  - Lấy trung bình hai tỷ lệ: (80% + 50%)/2 = 65% là sai vì số lệnh của hai chi nhánh khác nhau.
- **Ở lịch sử và CDC:**
  - Luôn JOIN với chi nhánh hiện tại, khiến doanh thu tháng 9 của Hà Nội bị chuyển sang Hải Phòng.
  - Mặc định CDC đồng nghĩa với MERGE ghi đè vào Fact; với `FACT_ORDER_EVENT` điều này làm mất lịch sử.
  - Coi capture time của CDC là business effective time.
  - Coi có CDC là đã có mô hình lịch sử phù hợp.
  - Pipeline chỉ xử lý partition ngày hiện tại nên bỏ sót late-arriving fact.
  - Mặc định mọi record trong ORDER_MATCHES đều được cộng vào doanh số.
- **Áp đặt một khuôn mẫu:** áp SCD2 cho mọi thuộc tính; áp Star Schema cho toàn bộ Gold; mỗi domain tự định nghĩa CUSTOMER.
- **Hiệu năng và chi phí:**
  - Mọi dashboard đều scan nhiều năm dữ liệu.
  - Ngược lại, tạo quá nhiều aggregate tables làm tăng chi phí lưu trữ, pipeline và quản lý consistency.
- **Rủi ro chung:** pipeline không lỗi, database chạy nhanh, nhưng measure định nghĩa sai thì dashboard vẫn kết luận sai.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **Schema OLTP của Oracle:** `CUSTOMER → ACCOUNT → {ORDERS → ORDER_MATCHES, CASH_TRANSACTION, SECURITIES_POSITION}`.
  - Core Trading được tối ưu để đặt lệnh nhanh, cập nhật khớp lệnh, kiểm tra số dư, giữ transaction consistency và hạn chế lock contention.
  - Yêu cầu "tổng giá trị khớp theo tháng × nhóm khách hàng × chi nhánh × mã chứng khoán trong 3 năm" sẽ cần nhiều JOIN, xử lý trạng thái và lịch sử nếu truy vấn trực tiếp.
- **Lệnh 1001, mã FPT, 1,000 cổ phiếu, khớp 3 lần (Hình 2):**

| MATCH_ID | QTY | PRICE | MATCHED_VALUE |
|---|---|---|---|
| M001 | 300 | 100,000 | 30,000,000 |
| M002 | 400 | 100,100 | 40,040,000 |
| M003 | 300 | 100,200 | 30,060,000 |

  - Tổng giá trị khớp = 100,100,000.
  - FACT_TRADE (grain = một lần khớp; cột MATCH_ID, ORDER_ID, ACCOUNT_KEY, SECURITY_KEY, TRADE_DATE_KEY, MATCHED_QUANTITY, MATCHED_PRICE, MATCHED_VALUE) có 3 dòng.
  - FACT_ORDER (grain = một lệnh; cột ORDER_ID, ACCOUNT_KEY, SECURITY_KEY, ORDER_DATE_KEY, ORDER_QUANTITY, ORDER_PRICE, CURRENT_STATUS) có 1 dòng.
- **Periodic Snapshot:** `FACT_ACCOUNT_BALANCE_DAILY` có grain một tài khoản × một ngày; cột SNAPSHOT_DATE_KEY, ACCOUNT_KEY, CASH_BALANCE, MARKET_VALUE, TOTAL_ASSET_VALUE, MARGIN_DEBT.
  - Hình 3: TOTAL_ASSET_VALUE của A001 là 500,000,000 (19/10/2026), 520,000,000 (20/10), 510,000,000 (21/10).
  - Hình 7: số dư của A001 là 100 triệu (19/10), 120 triệu (20/10), 110 triệu (21/10).
- **Surrogate key (Hình 5):** CUSTOMER_KEY 10001 ↔ CUSTOMER_ID C001 ↔ "Nguyen Van A". Ví dụ SCD1: "Nguyen Van A → Nguyen Van An".
- **SCD2 (Hình 6):** khách hàng C001 chuyển từ Hà Nội sang Hải Phòng ngày 1/10/2026.

| CUSTOMER_KEY | CUSTOMER_ID | BRANCH | VALID_FROM | VALID_TO |
|---|---|---|---|---|
| 10001 | C001 | Hanoi | 2025-01-01 | 2026-10-01 |
| 10002 | C001 | Hai Phong | 2026-10-01 | NULL |

  - Giao dịch ngày 15/9/2026 gắn với phiên bản Hà Nội; giao dịch ngày 15/10/2026 gắn với phiên bản Hải Phòng.
  - Nhờ vậy trả lời đúng câu hỏi "doanh thu môi giới của chi nhánh Hà Nội tháng 9".
- **Case study (mục 6):**
  - Nguồn: CUSTOMER, ACCOUNT, ORDERS, ORDER_MATCHES, SECURITIES, BRANCH, TRADING_CALENDAR.
  - Yêu cầu: giá trị khớp theo ngày, khối lượng theo mã, doanh thu môi giới theo chi nhánh, số lệnh đặt/khớp/hủy, tỷ lệ khớp, phân tích theo nhóm khách hàng.
  - Bước 1, business process: Order Placement, Order Matching, Trade Settlement, Brokerage Revenue, Account Valuation.
  - Bước 2, Fact: FACT_ORDER, FACT_TRADE, FACT_COMMISSION, FACT_ACCOUNT_BALANCE_DAILY.
  - Bước 3, Conformed Dimensions: DIM_CUSTOMER, DIM_ACCOUNT, DIM_SECURITY, DIM_BRANCH, DIM_DATE. DIM_SECURITY dùng chung cho FACT_ORDER, FACT_TRADE và FACT_POSITION_DAILY.
  - Mô hình khái niệm: FACT_TRADE nối DIM_CUSTOMER, DIM_DATE, DIM_SECURITY và DIM_ACCOUNT → DIM_BRANCH. Nếu Branch là chiều độc lập có lịch sử riêng, nên đặt BRANCH_KEY trực tiếp trong Fact.
- **Truy vấn SQL mẫu:** tính `SUM(MATCHED_VALUE)` (TOTAL_TRADING_VALUE) theo YEAR, MONTH, BRANCH_NAME, từ FACT_TRADE JOIN DIM_DATE (TRADE_DATE_KEY = DATE_KEY) và JOIN DIM_BRANCH (BRANCH_KEY). Kết quả có nghĩa vì grain rõ, measure có quy tắc tính, Dimension cung cấp ngữ cảnh và branch attribution đã được xác định trước.
- **CDC:** ORDERS chuyển trạng thái `NEW → PARTIALLY_MATCHED → COMPLETED`. FACT_ORDER (trạng thái mới nhất) được phép update; FACT_ORDER_EVENT (lịch sử) không được MERGE ghi đè.
- **Dữ liệu trễ và xử lý lại:**
  - Late fact: giao dịch có business date 20/10/2026 nhưng đến 21/10 mới vào platform.
  - Restatement: tháng 10 phát sinh điều chỉnh cho giao dịch tháng 9.
  - Backfill: rebuild FACT_TRADE từ 2026-09-01 đến 2026-09-30.
- **Non-additive:** `MATCH_RATE = MATCHED_ORDER_COUNT / ELIGIBLE_ORDER_COUNT`; định nghĩa matched order và eligible order phải thống nhất với business.
- **Quy mô:** FACT_TRADE có thể tăng thêm hàng triệu records mỗi ngày.

**9. Công nghệ/công cụ được nhắc tới**
- Oracle Core, Tibero, PostgreSQL, CRM, Market Data, APIs: hệ nguồn.
- Ingestion Full/Incremental/CDC/Streaming: đưa dữ liệu vào platform (đã bàn ở bài trước).
- Lakehouse với Bronze/Silver/Gold hoặc curated serving layer: nơi đặt Analytical Model.
- Kimball/Dimensional Modeling: phương pháp chính cho BI.
- Data Vault: dùng cho tích hợp, lưu lịch sử, audit.
- Microsoft Fabric và Power BI Semantic Model: thành phần quan trọng của lớp tiêu thụ; Power BI nằm ở tầng Consumption.
- SQL; các kỹ thuật partitioning, clustering, data skipping, incremental refresh.

**10. Checklist / câu hỏi thiết kế**
- Quy trình case study: xác định business process → thiết kế Fact theo grain → Conformed Dimensions → mô hình → kiểm tra truy vấn và quy tắc nghiệp vụ.
- Grain quyết định 8 điểm:
  - Primary hoặc unique business identifier.
  - Cách tính KPI.
  - Khả năng cộng gộp measure.
  - Cách JOIN giữa các Fact.
  - Cách xử lý update và CDC.
  - Kích thước dữ liệu.
  - Khả năng lưu lịch sử.
  - Chiến lược partition và clustering.
- Các danh sách đã nêu ở mục 5 và 6: metadata 7 trường của measure; 5 yêu cầu của backfill; 4 phương án cho late dimension; 3 câu hỏi restatement; 9 yếu tố performance/cost; 8 mục ownership & lifecycle.

**11. Kết luận & key takeaways**
- OLTP Schema không tự động trở thành Analytical Data Model tốt.
- Grain là quyết định nền tảng của Fact; thiếu grain rõ ràng sẽ dẫn đến fan-out, double counting và KPI sai.
- Fact ghi nhận sự kiện hoặc trạng thái; Dimension cung cấp ngữ cảnh. Hai loại bảng giải quyết hai vấn đề khác nhau.
- Lịch sử phải được thiết kế có chủ đích: SCD2, Periodic Snapshot và Event History phục vụ các nhu cầu khác nhau, không thể chỉ dựa vào CDC.
- Measure phải có aggregation semantics rõ: Trading Value, Cash Balance và Match Rate không được tổng hợp theo cùng một cách.
- Analytical Data Modeling là nền tảng cho Semantic Layer, Data Product và AI Analytics.
- Trích dẫn: "Xác định grain trước, sau đó mới lựa chọn Dimension và Measure."
- Trích dẫn: "Một Data Platform không trở nên có giá trị chỉ vì nó lưu trữ được nhiều dữ liệu." Theo tác giả, giá trị chỉ xuất hiện khi dữ liệu thành mô hình có ý nghĩa nghiệp vụ, kiểm chứng được, tái sử dụng được và hỗ trợ ra quyết định nhất quán.

**12. Liên kết với các bài khác**
- Tiếp nối Bài 7–8 (Full/Incremental Load, CDC, watermark, checkpoint, recovery). Mục 7 dựa trực tiếp trên CDC của Bài 8.
- Dùng lại khung Lakehouse Bronze/Silver/Gold đã có từ các bài trước.
- Mở đường cho Bài 10, "Semantic Layer & Metrics Governance – Từ Analytical Data Model đến Single Source of Truth cho Business Metrics":
  - Metadata của measure được nêu rõ là "nền tảng để xây dựng Semantic Layer ở Bài 10".
  - Mục 9 chỉ giới thiệu sơ lược Semantic Model.
  - Câu hỏi chuyển tiếp: làm sao để mọi dashboard, ứng dụng và AI Agent hiểu chung Trading Value, Brokerage Revenue, Active Customer, Risk Exposure.
- Có nhắc đến Data Product (yêu cầu completeness/consistency), chuẩn bị cho các bài sau.

---

## Bài 10: Modern Data Platform – Bài 10: Semantic Layer & Metrics Governance – Xây dựng Single Source of Truth cho Business Metrics
*Subtitle: From Analytical Data Models to Consistent, Governed and Reusable Business Metrics · Đăng 2026-10-10 · 5 hình/bảng (đã đọc hết)*

Mục lục (H2): 1. Từ Analytical Data Model đến Semantic Layer: vì sao Fact và Dimension vẫn chưa đủ? | 2. Business Metrics: phân biệt Measure, Metric và KPI | 3. Metric Definition: một chỉ số cần được định nghĩa những gì? | 4. Metrics Governance: ai được quyền định nghĩa và thay đổi KPI? | 5. Conformed Metrics: làm thế nào bảo đảm nhiều dashboard dùng cùng một định nghĩa? | 6. Time Intelligence: một trong những nguồn gây sai lệch KPI lớn nhất | 7. Semantic Layer Architecture: Centralized, Domain-Oriented và Hybrid | 8. Semantic Layer trên Microsoft Fabric và các công nghệ khác | 9. Metrics as Code: Versioning, Testing và CI/CD | 10. Case Study: xây dựng Enterprise Metrics Platform cho công ty chứng khoán | Kết luận: Single Source of Truth bắt đầu từ sự thống nhất về ý nghĩa dữ liệu

**1. Bối cảnh & vấn đề mở đầu**
- Công ty đã có Star Schema tốt từ Bài 9: FACT_TRADE, FACT_ORDER, FACT_COMMISSION, FACT_ACCOUNT_BALANCE_DAILY cùng DIM_CUSTOMER, DIM_ACCOUNT, DIM_SECURITY, DIM_BRANCH, DIM_DATE.
- Ba bộ phận dùng chung một Lakehouse: Trading theo dõi Trading Value, Finance theo dõi Brokerage Revenue, Risk theo dõi Customer Exposure. Khi đối chiếu, Total Trading Value vẫn ra ba số: Trading 120 tỷ, Finance 118 tỷ, Management 123 tỷ.
- Nguyên nhân không nhất thiết nằm ở ingestion, CDC hay Data Quality, mà ở định nghĩa:
  - A: `SUM(MATCHED_VALUE)`.
  - B: thêm `WHERE TRADE_STATUS='SETTLED'`.
  - C: thêm `WHERE TRADE_DATE = REPORT_DATE`.
- Mỗi công thức hợp lệ trong ngữ cảnh riêng nhưng không cùng một định nghĩa. Thiếu quản trị thì mỗi dashboard trở thành nơi tự định nghĩa business logic.

**2. Luận điểm cốt lõi**
Cần Semantic Layer cùng Metrics Governance. Đây không chỉ là thêm một lớp dữ liệu, mà là một hệ thống gồm định nghĩa có cấu trúc, ownership, phê duyệt, versioning, kiểm thử và kiểm soát truy cập. Hệ thống này giúp mọi consumer (BI, SQL, API, AI Agent) dùng business metric theo cùng một định nghĩa đã được quản trị. Single Source of Truth là sự thống nhất về ý nghĩa, không phải về một database.

**3. Khái niệm chính**
- **Business semantics:** những câu hỏi mà Fact/Dimension chưa tự trả lời:
  - Trading Value được tính chính xác thế nào?
  - Giao dịch bị hủy hoặc điều chỉnh có được tính không?
  - Active Customer xác định theo giao dịch hay theo đăng nhập?
  - Doanh thu ghi nhận theo trade date hay accounting date?
  - Khách hàng chuyển chi nhánh thì doanh thu lịch sử thuộc chi nhánh nào?
  - Ai có quyền thay đổi công thức KPI?
- **Semantic Layer:** lớp trừu tượng mô tả dữ liệu bằng khái niệm nghiệp vụ, để consumer không phải hiểu toàn bộ cấu trúc vật lý.
  - Nó quản lý Business Entities, Dimensions, Measures, Metrics, Relationships, Time Semantics, Business Definitions và Access Policies.
  - Nó không nhất thiết là một database riêng. Có thể triển khai bằng Power BI Semantic Model, metrics layer độc lập, SQL views hoặc curated query interfaces, semantic modeling frameworks, metrics API, hoặc kết hợp.
  - Điều cốt lõi: business definitions "được quản lý tập trung về mặt logic và được sử dụng nhất quán".
- **Measure:** giá trị tính toán hoặc tổng hợp từ dữ liệu, ví dụ Matched Quantity, Matched Value, Commission Amount, Order Count, `SUM(FACT_TRADE.MATCHED_VALUE)`. Measure gắn với mô hình dữ liệu.
- **Metric:** chỉ số có ý nghĩa nghiệp vụ, xây từ một hoặc nhiều measure cộng quy tắc tính.
  - Ví dụ: Total Trading Value, Active Trading Customers, Average Trading Value per Customer, Order Match Rate, Brokerage Revenue.
  - Cần thêm Business Definition, Filter Conditions, Time Semantics, Aggregation Rule, Applicable Dimensions. Metric gắn với business definition.
- **KPI:** metric gắn với mục tiêu quản trị hoặc hiệu quả hoạt động. KPI gắn với business objective.
  - Ví dụ: "Monthly Brokerage Revenue" → "Monthly Brokerage Revenue Achievement".
  - Achievement Rate = Actual / Target.
- **Metric Contract:** định nghĩa metric dạng metadata có cấu trúc và quản trị được. Đây là mức kiến trúc, không phải cú pháp bắt buộc của Power BI hay dbt.
- **Metric Registry:** danh mục metric kèm Owner, Status, Version. Có thể nằm trong semantic platform, catalog hoặc repository.
- **Conformed Metrics:** tương tự Conformed Dimension của Bài 9; metric có định nghĩa nhất quán và được tái sử dụng giữa nhiều consumer.
- **Thời gian:**
  - Event Time: thời điểm sự kiện thực sự xảy ra. Processing Time: thời điểm pipeline xử lý.
  - Business Calendar: lịch giao dịch, ngày nghỉ, lịch thanh toán, kỳ kế toán.
  - MTD/QTD/YTD: các metric period-to-date.
  - As-of Reporting: Current Restated View (số lịch sử đã cập nhật theo thông tin mới nhất) và As-Published View (số đã công bố tại một thời điểm).
- **Kiến trúc và cách quản lý:**
  - Centralized / Domain-Oriented / Hybrid semantic architecture.
  - Import / DirectQuery / Direct Lake (các chế độ truy cập dữ liệu của Power BI/Fabric).
  - Metrics as Code; metric versioning và breaking change.

**4. Kiến trúc, pattern & quy trình**
- **Luồng ngữ nghĩa:** `Physical Data Model → FACT_TRADE.MATCHED_VALUE → Semantic Definition → Total Trading Value → Business Consumption`.
- **Conformed metrics:** `Governed Metric Definition → Semantic Interface → {Power BI | SQL/API | Applications}`.
  - Không bắt buộc một semantic engine duy nhất cho mọi workload.
  - Có thể dùng Power BI Semantic Model cho BI, SQL interface cho ad-hoc, Metrics API cho ứng dụng, governed query interface cho AI.
- **Approval workflow:** `Metric Proposal → Business Definition → Technical Feasibility Review → Business Approval → Implementation & Testing → Published Metric → Monitoring & Change Management`.
- **Ba mô hình kiến trúc semantic:**
  - Centralized: `Central Semantic Team → Enterprise Metrics → Trading/Finance/Risk`.
  - Domain-Oriented: mỗi domain sở hữu metric của mình (Trading/Finance/Risk Metrics).
  - Hybrid: `Enterprise Metrics Governance → Shared Definitions → {Trading, Finance, Risk Metrics} → Shared Consumers`.
- **Phân vai trong Hybrid:**
  - Enterprise Governance quản lý tiêu chuẩn và các metric dùng chung.
  - Domain sở hữu business logic thuộc phạm vi của mình.
  - Platform cung cấp tooling, deployment và access control.
  - Metric có thể được discover và tái sử dụng.
- **Trên Fabric:** `Oracle/Tibero/PostgreSQL → Ingestion → Fabric Lakehouse → Analytical Model → Power BI Semantic Model → Power BI Reports`.
- **Ngoài Power BI:** `Governed Metrics → Semantic/Metrics API → {Power BI | SQL Clients | AI Agents}`.
- **Repo Metrics as Code (`semantic-platform/`, layout tham khảo):**
  - `metrics/trading/{total_trading_value, active_trading_customer, order_match_rate}.yaml`
  - `metrics/finance/brokerage_revenue.yaml`, `metrics/risk/margin_exposure.yaml`
  - `models/{trading,finance,risk}`
  - `tests/{metric_consistency,aggregation,regression}`
  - `docs/metric_catalog.md`
- **CI/CD:** `Metric Definition Change → Git Pull Request → Schema Validation → Metric Testing → Impact Analysis → Business Approval → Deploy to Staging → Regression Testing → Production Release`.
- **Kiến trúc case study:**
  - SOURCE SYSTEMS (Oracle/Tibero/PostgreSQL/CRM)
  - → DATA PLATFORM (Ingestion/CDC/Bronze/Silver)
  - → ANALYTICAL DATA MODEL (Fact/Dimension/Snapshot/History)
  - → SEMANTIC PLATFORM (Metric Registry, Business Definitions, Semantic Models, Access Policies, Versioning & Testing)
  - → {Power BI | Metrics API | AI Agents}
  - Đây là các năng lực logic, không bắt buộc phải là service hay container riêng.
- **Luồng AI:** `User Question → AI Agent → Semantic Metadata → Governed Metric Query → Authorized Data Access → Business Answer`.

**5. Framework ra quyết định & so sánh**

Phân biệt các thành phần (Hình 1):

| Thành phần | Ví dụ |
|---|---|
| Measure | Commission Amount |
| Metric | Monthly Brokerage Revenue |
| KPI | Brokerage Revenue Target Achievement |
| Dimension | Branch, Customer Segment |
| Time Dimension | Trading Date, Accounting Date |

Nguyên tắc: không phải measure nào cũng là KPI, và không phải KPI nào cũng nên hardcode vào bảng dữ liệu.

Năm yếu tố của một metric definition:

| Yếu tố | Nội dung |
|---|---|
| Business Meaning | Metric đại diện cho điều gì |
| Grain | Tính từ loại sự kiện nào, ví dụ "one row per execution / matched trade"; grain mơ hồ dẫn đến double counting |
| Time Semantics | Order Date, Trade Date, Settlement Date hay Accounting Date; hai chỉ số khác time semantics không được dùng chung một tên |
| Filter Rules | Record nào được tính hoặc loại; phải được business và hệ nguồn xác nhận |
| Aggregation Semantics | Trading Value nhìn chung additive qua các execution hợp lệ; Cash Balance không additive theo thời gian; Match Rate phải tính lại từ numerator/denominator |

- **Ai định nghĩa metric:** nếu Data Engineering tự quyết công thức thì dễ lệch nghiệp vụ; nếu mỗi Business Team tự quyết thì doanh nghiệp mất nhất quán. Vì vậy cần một mô hình quản trị.
- **Vai trò trong Metrics Governance:**
  - Business Metric Owner: chịu trách nhiệm ý nghĩa nghiệp vụ, ví dụ Brokerage Revenue thuộc Finance.
  - Data Owner: phạm vi dữ liệu và trách nhiệm quản lý dữ liệu của domain.
  - Data Steward: định nghĩa, metadata, chất lượng, tuân thủ quy tắc.
  - Data Platform/Analytics Engineering: triển khai logic kỹ thuật, kiểm thử, versioning, vận hành.
  - Metric Consumer: dùng metric qua dashboard, ứng dụng hoặc API.

Metric Registry (Hình 2):

| Metric | Owner | Status | Version |
|---|---|---|---|
| Total Trading Value | Trading | Approved | 1.0 |
| Brokerage Revenue | Finance | Approved | 1.2 |
| Active Trading Customer | Trading | Draft | 2.0 |
| Margin Exposure | Risk | Approved | 1.0 |

Ba kiến trúc Semantic Layer (từ text):

| Kiến trúc | Ưu điểm | Hạn chế |
|---|---|---|
| Centralized | Dễ kiểm soát định nghĩa chung; một nơi quản lý thay đổi; hợp khi có ít domain hoặc KPI cần quản trị tập trung | Nhóm trung tâm thành bottleneck; domain phải chờ; semantic model quá lớn, khó bảo trì |
| Domain-Oriented | Domain chủ động; logic gần người hiểu nghiệp vụ; phát triển độc lập | Dễ trùng định nghĩa; cần governance chung; cross-domain analytics phức tạp |
| Hybrid | Kết hợp governance chung với quyền sở hữu của domain; tác giả xem là "đáng cân nhắc cho Enterprise" | Data Mesh không chỉ là chia Semantic Layer thành nhiều nhóm; còn cần ownership, self-service platform và federated governance |

- **Import / DirectQuery / Direct Lake:**
  - Import nạp dữ liệu vào semantic model và cần refresh.
  - DirectQuery đẩy truy vấn xuống nguồn khi người dùng tương tác.
  - Direct Lake cho semantic model làm việc với dữ liệu Delta trong OneLake.
  - Ba chế độ khác nhau về Performance, Freshness, Memory Usage, Query Behavior, Model Compatibility và Operational Cost.
  - Không nên mặc định Direct Lake luôn nhanh hơn hay tốt hơn. Lựa chọn tùy mô hình, workload, dung lượng, yêu cầu freshness và giới hạn hiện hành của Fabric.
- **Semantic layer ngoài Power BI:** dbt Semantic Layer và MetricFlow, Cube, semantic capabilities của BI platforms, custom metrics service. Các sản phẩm này không tương đương nhau về phạm vi tính năng, deployment model và khả năng tích hợp.

Tiêu chí đánh giá công cụ Semantic Layer (Hình 3):

| Tiêu chí | Câu hỏi kiến trúc |
|---|---|
| Metric definition | Có hỗ trợ định nghĩa metric có cấu trúc? |
| Reusability | Nhiều consumer có dùng được không? |
| Governance | Có owner, versioning, approval? |
| Access control | Có kiểm soát quyền theo consumer? |
| Performance | Query được thực thi ở đâu? |
| Integration | Có hỗ trợ BI, SQL, API cần thiết? |
| Cost | Chi phí compute, caching, vận hành thế nào? |

Nguyên tắc: chọn Semantic Layer theo hệ sinh thái tiêu thụ dữ liệu và yêu cầu quản trị, không theo số lượng tính năng.

- **Versioning:** nếu thay đổi chạm tới business semantics thì phải đánh giá xem có phải breaking change không. Có thể chạy song song v1.0 và v2.0 trong giai đoạn chuyển đổi. Không cần nhiều phiên bản vật lý cho mọi metric, nhưng hệ thống phải biết định nghĩa nào đã áp dụng tại từng thời điểm quan trọng.

**6. Best practices / nguyên tắc thiết kế**
- **Định nghĩa metric:**
  - Thống nhất cách phân biệt Measure/Metric/KPI ở cấp kiến trúc, dù mỗi công cụ gọi khác nhau.
  - Mỗi metric phải có đủ 5 yếu tố định nghĩa và được đóng gói thành Metric Contract.
- **Quản trị thay đổi:**
  - Phân vai rõ ràng và có quy trình phê duyệt.
  - Thay đổi ngữ nghĩa phải đi kèm versioning và impact analysis.
  - Metric Registry có cơ chế kiểm soát và tra cứu.
- **Nhiều implementation cho nhiều consumer:** chấp nhận được, nhưng phải có consistency testing. Khi so sánh cần thống nhất thời điểm refresh, filter, quyền truy cập và quy tắc làm tròn.
- **Thời gian:**
  - Tính theo event time phù hợp, không theo processing time.
  - Business calendar (trading session, holiday, settlement) phải lấy từ nguồn nghiệp vụ có thẩm quyền.
  - MTD phải định nghĩa rõ: tính đến ngày nào; có gồm ngày hiện tại chưa hoàn tất không; dùng trade date hay accounting date; có tính adjustment sau ngày chốt không; dùng snapshot hiện tại hay snapshot lúc công bố.
  - Nếu cần cả restated view lẫn as-published view, kiến trúc phải hỗ trợ versioning, snapshot hoặc lưu lịch sử phù hợp.
- **Kiến trúc:** dùng Hybrid cho enterprise; quản lý metric như code: version control, Pull Request, 6 loại test, staging, regression rồi mới release.
- **Bảo mật:** áp dụng RLS, CLS, masking nhất quán giữa BI và API.
- **AI:** cung cấp cho AI Agent các metric và dimension đã phê duyệt. Với dữ liệu tài chính, ưu tiên governed metric hoặc query interface thay vì để AI tự do chạy SQL.
- **Đo thành công:** dựa vào mức quản trị và tái sử dụng, không dựa vào số lượng metric.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- **Định nghĩa phân tán:**
  - Mỗi dashboard tự định nghĩa logic.
  - SQL công thức A, DAX công thức B, Python công thức C: ban đầu có thể giống nhau, nhưng sẽ lệch khi business rule thay đổi.
  - Chỉ Data Engineering quyết công thức, hoặc mỗi team nghiệp vụ tự quyết.
- **Thay đổi không kiểm soát:**
  - Đổi định nghĩa Active Trading Customer mà không versioning hay impact analysis, khiến dashboard lịch sử đổi số mà người dùng không biết lý do.
  - Sửa metric trực tiếp trên production; khi đó không trả lời được: ai đã sửa, có được phê duyệt không, dashboard nào bị ảnh hưởng, có rollback được không, version nào đang dùng.
- **Sai về thời gian:**
  - Đặt cùng một tên cho hai metric khác time semantics.
  - Tính theo processing time, khiến event trễ rơi vào sai kỳ báo cáo.
  - Suy ra ngày giao dịch chỉ bằng cách bỏ thứ Bảy và Chủ nhật.
  - Kỳ vọng Semantic Layer khôi phục được trạng thái lịch sử mà platform chưa từng lưu.
- **Sai về kiến trúc:**
  - Central team thành bottleneck; một semantic model quá lớn.
  - Các domain định nghĩa trùng nhau.
  - Coi Data Mesh đơn giản là chia Semantic Layer thành nhiều nhóm.
  - Mặc định Direct Lake luôn tốt hơn.
  - Có công cụ semantic mạnh nhưng thiếu owner, approval và versioning.
  - Nghĩ rằng dùng chung một Lakehouse thì các dashboard sẽ ra cùng KPI.
- **Bảo mật:** metric định nghĩa đúng nhưng làm lộ dữ liệu ngoài phạm vi cho phép vẫn là thiết kế không đạt.
- **AI:**
  - Để LLM tự suy luận bảng, JOIN và công thức, hoặc tự do chạy SQL không giới hạn.
  - Tin rằng Semantic Layer tự loại bỏ được hallucination.
- **Đo sai thành công:** đếm số metric. Theo tác giả, 500 metric mà không ai biết cái nào chính thức có thể kém hữu ích hơn 50 metric được quản trị tốt.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **KPI:** doanh thu thực tế 12 tỷ, mục tiêu 15 tỷ, Achievement Rate = 80%.
- **Business Meaning mẫu:** "Tổng giá trị các giao dịch chứng khoán được khớp hợp lệ trong phạm vi báo cáo, theo quy tắc ghi nhận giao dịch của doanh nghiệp."
- **Time semantics:** một giao dịch khớp ngày 20/10 nhưng thanh toán sau đó. Trading quan tâm trade date; Finance có thể dùng accounting date cho một chỉ số khác.
- **Filter rules:**
  - Gồm: các valid matched executions.
  - Loại hoặc điều chỉnh theo policy: execution bị hủy hoặc vô hiệu, transaction bị reversal, duplicate source events.
- **Metric Contract `total_trading_value`:**
  - display_name: Total Trading Value; owner: trading_analytics.
  - source_model: fact_trade; measure: matched_value, aggregation sum.
  - time_dimension: trade_date; dimensions: branch, customer_segment, security, market.
  - filters: eligible_trade = true; unit: VND; status: approved; version: 1.0.0.
- **Đổi định nghĩa Active Trading Customer:** định nghĩa cũ là khách hàng có ít nhất một matched trade trong kỳ; định nghĩa mới là ít nhất một eligible order. Đây là thay đổi ý nghĩa nghiệp vụ, không chỉ là sửa SQL.
- **Consistency test:** metric Total Trading Value, kỳ 2026-10-01 đến 2026-10-20, chi nhánh Hà Nội. Yêu cầu kết quả Power BI = SQL Reference = Metrics API.
- **Các loại timestamp của một giao dịch:** ORDER_CREATED_AT, MATCHED_AT, SETTLEMENT_DATE, ACCOUNTING_DATE, INGESTED_AT. Ví dụ Trade Matched 10:00:05 → CDC Captured 10:00:07 → Lakehouse Processed 10:00:12.
- **Calendar Dimension:**
  - Khái niệm nghiệp vụ: Trading Day, Non-Trading Day, Holiday, Settlement Calendar, Accounting Period.
  - Cột: DATE_KEY, CALENDAR_DATE, DAY_OF_WEEK, IS_TRADING_DAY, TRADING_SESSION, MONTH, QUARTER, YEAR.
- **As-of reporting:** báo cáo ngày 30/9 công bố ngày 1/10; ngày 3/10 phát sinh adjustment cho giao dịch tháng 9. Khi chạy lại báo cáo, phải chọn hiển thị restated hay as-published.
- **DAX mẫu:** `Total Trading Value = CALCULATE(SUM(FACT_TRADE[MATCHED_VALUE]), FACT_TRADE[ELIGIBLE_TRADE] = TRUE())`. Cờ ELIGIBLE_TRADE phải xây theo quy tắc nghiệp vụ thực tế.
- **Quy mô cần Metrics as Code:** hơn 100 metric, hơn 20 semantic model, hơn 50 dashboard, nhiều domain. Ví dụ `total_trading_value` lên v2.0 khi bổ sung một loại giao dịch trước đây chưa được tính.
- **Case study:**
  - Nguồn: Oracle Core Trading, Tibero, PostgreSQL, CRM, Market Data.
  - Domain: Trading, Finance, Risk, Customer.
  - Metric Catalog (Hình 4):

| Domain | Metric | Business Owner |
|---|---|---|
| Trading | Total Trading Value | Trading |
| Trading | Order Match Rate | Trading |
| Trading | Active Trading Customers | Trading |
| Finance | Brokerage Revenue | Finance |
| Risk | Margin Exposure | Risk |
| Customer | Customer Asset Value | Customer/Business Owner |

  - Owner thực tế phải được doanh nghiệp xác nhận.
- **Contract `order_match_rate`:**
  - owner: trading; numerator: matched_order_count; denominator: eligible_order_count; calculation: ratio.
  - time_dimension: order_date; dimensions: branch, customer_segment, channel; format: percentage; version: 1.0.0.
  - Phải làm rõ thế nào là matched order và eligible order. Nếu một order có nhiều execution, numerator phải tính ở đúng grain để tránh double counting.
- **Metric nhạy cảm cần thiết kế security:** Customer Asset Value, Margin Exposure, Brokerage Revenue.
- **Câu hỏi AI mẫu:** "Tổng giá trị giao dịch của khách hàng VIP tại Hà Nội trong tháng 10 là bao nhiêu?"

**9. Công nghệ/công cụ được nhắc tới**
- **Power BI Semantic Model:** định nghĩa tables và relationships, measures, calculated columns, hierarchies, row-level security, metadata thân thiện với business. DAX là ngôn ngữ viết measure.
- **Microsoft Fabric, Fabric Lakehouse, OneLake (Delta):** nền tảng dữ liệu bên dưới; Import, DirectQuery, Direct Lake là các chế độ truy cập.
- **dbt Semantic Layer và MetricFlow, Cube, semantic capabilities của BI platforms, custom metrics services:** lựa chọn khi có nhiều consumer ngoài Power BI.
- **SQL views/curated query interfaces, Metrics API, semantic modeling frameworks:** các cách hiện thực Semantic Layer.
- **Git (Pull Request), CI/CD, YAML:** công cụ cho Metrics as Code (YAML chỉ mang tính tham khảo).
- **Catalog/repository:** nơi đặt Metric Registry.
- **AI Agents/LLM:** consumer của governed metrics.
- **Hệ nguồn:** Oracle, Tibero, PostgreSQL, CRM, Market Data.

**10. Checklist / câu hỏi thiết kế**
- **Case study 6 bước:**
  1. Metric Catalog.
  2. Metric Contract.
  3. Semantic Architecture.
  4. Security: ai được xem metric; ai được xem dữ liệu chi tiết; có cần RLS, CLS, masking không; quyền có nhất quán giữa BI và API không.
  5. Tích hợp AI: AI phải xác định đúng metric, đúng time range, áp đúng filter, tôn trọng access policies, xử lý câu hỏi mơ hồ, trả về nguồn hoặc thông tin kiểm chứng.
  6. Tiêu chí nghiệm thu (bảng dưới).
- **Sáu loại test:** Definition Validation, SQL/Semantic Validation, Aggregation Testing, Reconciliation Testing, Regression Testing, Access Control Testing.
- **Quy trình:** workflow phê duyệt 7 bước và pipeline CI/CD 9 bước (xem mục 4); 5 câu hỏi MTD (xem mục 6); 7 tiêu chí chọn công cụ (Hình 3).
- **Tiêu chí nghiệm thu (Hình 5):**

| Tiêu chí | Mục tiêu |
|---|---|
| Metric Ownership | Metric quan trọng có business owner |
| Definition Consistency | Consumer dùng định nghĩa đã được phê duyệt |
| Metric Discoverability | Có thể tìm kiếm và hiểu metric |
| Version Control | Thay đổi quan trọng có lịch sử |
| Regression Testing | Có kiểm thử khi cập nhật |
| Security | Quyền truy cập được thực thi |
| Performance | Đáp ứng workload và SLA |
| Auditability | Truy vết được định nghĩa và thay đổi |

**11. Kết luận & key takeaways**
- Dữ liệu nằm chung một Lakehouse không có nghĩa các dashboard sẽ tính KPI giống nhau.
- Semantic Layer tách business meaning khỏi cấu trúc dữ liệu vật lý; người dùng không cần hiểu bảng, khóa và JOIN.
- Metrics Governance quan trọng không kém semantic technology; công cụ mạnh mà thiếu owner, approval và versioning vẫn sinh định nghĩa không nhất quán.
- Time semantics và aggregation semantics phải được quản lý rõ; metric có thể sai dù SQL đúng.
- Single Source of Truth không bắt buộc mọi consumer truy vấn cùng một database; điều cần thống nhất là business definition, scope và semantics.
- Semantic Layer là nền cho Self-Service Analytics và AI Analytics.
- Trích dẫn: "Single Source of Truth không nhất thiết có nghĩa mọi consumer phải truy vấn cùng một database." Tác giả nói tiếp: các consumer cần dùng cùng một định nghĩa nghiệp vụ đã được quản trị.
- Trích dẫn: "Nó còn cần một nguồn định nghĩa nghiệp vụ đáng tin cậy, để cùng một câu hỏi business không tạo ra nhiều câu trả lời". Câu này tiếp nối ý rằng platform không chỉ cần nguồn dữ liệu đáng tin cậy.

**12. Liên kết với các bài khác**
- **Kế thừa trực tiếp Bài 9:**
  - Dùng lại Fact, Dimension, Grain, SCD và Star Schema.
  - Conformed Dimension được mở rộng thành Conformed Metrics.
  - Metadata của measure trong Bài 9 phát triển thành Metric Contract.
  - Bài 9 đã hứa hẹn nội dung của Bài 10.
- **Liên hệ với các bài ingestion:** tác giả nhắc ingestion, CDC và Data Quality chỉ để loại trừ chúng khỏi nguyên nhân gây lệch số. [Ghi chú: phân biệt event time với thời điểm CDC capture là liên hệ ngầm với Bài 8; bài không ghi rõ số bài.]
- **Mở đường cho Bài 11**, "Data Product Design & Lifecycle Management – Từ Dataset đến Data Product có Ownership, Contract và SLA": làm sao đóng gói dữ liệu đã mô hình hóa và metric đã quản trị thành Data Product discover được, vận hành được.
- **Các bài sau:** Hybrid architecture được nêu là nền cho Data Product và Data Mesh. AI Agent và governed query interface đặt nền cho chủ đề AI Analytics.

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **"Cùng một chỉ số, nhiều con số":** cả hai bài mở đầu bằng Trading Value = 120/118/123 tỷ. Nguyên nhân thường nằm ở định nghĩa (grain, time semantics, filter), không phải ở ingestion hay chất lượng dữ liệu nguồn. Lời giải đi theo hai tầng: Analytical Model cho cấu trúc, rồi Semantic Layer cùng Governance cho ý nghĩa.
- **Semantics trước công nghệ:** grain, aggregation semantics (additive, semi-additive, non-additive; tính Match Rate từ numerator/denominator) và time semantics là các quyết định nền tảng. Tác giả liên tục cảnh báo việc "mặc định": Star Schema cho mọi Gold, Snowflake tốt hay kém hơn, Direct Lake luôn nhanh hơn, CDC tương đương MERGE hay tương đương lịch sử.
- **Lịch sử và thời gian phải thiết kế có chủ đích:** SCD2 với business effective time và capture time; event time và processing time; late-arriving data; backfill; restatement; restated view và as-published view. Semantic Layer không thể khôi phục thứ mà platform chưa từng lưu.
- **Ownership, versioning, lifecycle và impact analysis quan trọng ngang kỹ thuật:** Model Owner và Deprecation Policy ở Bài 9; Metric Owner, approval workflow, Metric Registry và Metrics as Code ở Bài 10.
- **Phân tách trách nhiệm theo lớp quan trọng hơn tên lớp:** Source → Ingestion → Bronze → Silver → Analytical Model → Semantic → Consumption. Các khối kiến trúc là năng lực logic, không bắt buộc thành service riêng. Mô hình Hybrid (chuẩn dùng chung, domain sở hữu logic) chuẩn bị cho Data Product và Data Mesh.
- **Đo giá trị bằng tính nhất quán và tái sử dụng, không bằng số lượng:** lưu nhiều dữ liệu, tạo nhiều aggregate table hay nhiều metric đều không tự tạo ra giá trị. Kịch bản chứng khoán (FACT_TRADE/MATCHED_VALUE, chi nhánh Hà Nội → Hải Phòng, Order Match Rate) được dùng xuyên suốt để minh họa.

---

# Tóm tắt series "Modern Data Platform" (Duong Pham) – Bài 11–12

## Bài 11: Modern Data Platform – Bài 11: Data Governance, Data Catalog, Lineage & Ownership – Quản trị dữ liệu ở quy mô Enterprise
*Subtitle: Xây dựng nền tảng quản trị giúp doanh nghiệp biết mình có dữ liệu gì, dữ liệu đến từ đâu, ai chịu trách nhiệm và dữ liệu có thể được sử dụng như thế nào. Đăng ngày 2026-10-11. Bài có 8 bảng dạng ảnh (đã xem đủ cả 8).*

Mục lục (H2): 1. Data Governance là gì và tại sao Data Platform cần Governance? | 2. Metadata Management – Nền tảng của Data Governance | 3. Data Catalog – Làm thế nào để tìm và hiểu dữ liệu? | 4. Business Glossary – Chuẩn hóa ngôn ngữ dữ liệu trong doanh nghiệp | 5. Data Lineage – Truy vết dữ liệu từ Source đến Business Report | 6. Data Ownership – Ai thực sự chịu trách nhiệm với dữ liệu? | 7. Data Classification, Access Governance & Data Lifecycle | 8. Governance Architecture – Thiết kế Data Governance như một năng lực dùng chung | 9. Enterprise Governance Operating Model – Làm thế nào để Governance thực sự hoạt động? | 10. Case Study: Data Governance cho Securities Data Platform | Kết luận

**1. Bối cảnh & vấn đề mở đầu**

Bài này nối tiếp Bài 10 (Semantic Layer & Metrics Governance). Tác giả giả định một platform đã phình to: 20 hệ thống nguồn, 500 pipelines, 2.000 datasets, 300 dashboards, hàng trăm business metrics, và nhiều đội DE/BI/Risk/Finance/Operations cùng dùng dữ liệu. Ở quy mô này, thách thức không còn nằm ở việc xây thêm pipeline. Câu hỏi thật sự là:
- Dataset được tạo từ hệ thống nào?
- Bao nhiêu bảng đang chứa thông tin khách hàng?
- Hai dataset trùng tên khác nhau ở điểm nào?
- Nguồn đổi schema thì báo cáo nào bị ảnh hưởng?
- Ai chịu trách nhiệm khi dữ liệu sai?
- Dữ liệu có thông tin nhạy cảm không? Ai được truy cập, ai được chia sẻ?
- Dataset nào còn được dùng, dataset nào đã hết giá trị?

Nếu không có governance, platform vẫn "chạy" về mặt kỹ thuật nhưng khó hiểu, khó kiểm soát và khó mở rộng.

**2. Luận điểm cốt lõi**
- Data Governance là một năng lực kiến trúc cốt lõi, không phải phần bổ sung sau khi platform đã xong.
- Governance không đồng nghĩa với một phần mềm hay một Data Catalog. Đó là cách doanh nghiệp ra quyết định và thực thi trách nhiệm đối với dữ liệu.
- Một kiến trúc governance tốt phải biến nguyên tắc thành metadata, ownership, policies, workflows và cơ chế kiểm soát áp dụng được, xuyên suốt từ nguồn đến consumer.

**3. Khái niệm chính**
- **Data Governance**
  - Là tập hợp nguyên tắc, chính sách, vai trò, quy trình và cơ chế kiểm soát để dữ liệu được quản lý và sử dụng đúng mục đích trong toàn bộ vòng đời.
  - Trả lời ba câu hỏi: ai chịu trách nhiệm, dữ liệu được định nghĩa và kiểm soát theo quy tắc nào, và quy tắc đó được thực thi ra sao.
  - Không phải là Data Catalog, cũng không chỉ là việc cấp quyền truy cập.
- **Data Quality so với Governance**
  - Data Quality (Bài 6) hỏi: dữ liệu có chính xác, đầy đủ, hợp lệ và đáp ứng yêu cầu không?
  - Governance hỏi: ai đặt ra yêu cầu, ai chịu trách nhiệm, và yêu cầu được quản lý thế nào trên toàn doanh nghiệp?
  - Hai năng lực bổ sung cho nhau. Dữ liệu tốt nhưng không rõ owner, nguồn gốc hay chính sách sử dụng thì vẫn thiếu governance. Ngược lại, có đủ chính sách nhưng pipeline thường tạo dữ liệu sai thì platform vẫn chưa đáng tin cậy.
  - Governance chỉ có giá trị khi chính sách được gắn vào thiết kế, phát triển và vận hành.
- **Metadata** là "dữ liệu mô tả dữ liệu", chia thành 4 nhóm:
  - *Technical metadata*: database/schema/table, tên và kiểu cột, PK/FK, storage location, partitioning, file format, schema version. Nhóm này thu thập tự động được qua connectors, metadata scanners hoặc platform APIs.
  - *Business metadata*: mục đích của dataset, thuật ngữ nghiệp vụ, business owner, quy trình nghiệp vụ mà dữ liệu phục vụ, giới hạn khi diễn giải. Ví dụ, định nghĩa `trade_amount` là tổng giá trị khớp lệnh (giá khớp × khối lượng khớp, chưa gồm phí và thuế) quan trọng hơn nhiều so với việc biết kiểu dữ liệu là `DECIMAL(20,2)`.
  - *Operational metadata*: last successful update, last ingestion time, trạng thái pipeline, freshness, record count, kết quả DQ, thời lượng job. Đây là đầu vào cho Data Observability (Bài 13).
  - *Governance metadata*: owner, steward, classification, retention policy, access policy, liên kết với glossary, approved usage.
  - Metadata không được quản lý như tài liệu tĩnh; nó phải cập nhật theo vòng đời hệ thống. Nhờ Metadata Management, platform chuyển từ chỗ "chỉ lưu trữ" sang "hiểu và kiểm soát" dữ liệu.
- **Data Catalog**
  - Là lớp giúp người dùng khám phá, tìm kiếm, hiểu và đánh giá các data assets.
  - Catalog tốt phải trả lời được: tìm dữ liệu ở đâu, dataset nào đã được kiểm chứng và phê duyệt, dataset nào đang phục vụ báo cáo doanh thu, ai giải thích được ý nghĩa, tần suất cập nhật, và tôi có quyền truy cập không.
- **Metadata Repository**
  - Là nơi lưu metadata và quan hệ giữa các metadata entities. Catalog là lớp discovery/search chạy trên repository đó; nhiều sản phẩm gộp cả hai.
  - Catalog không lưu dữ liệu nghiệp vụ. Dữ liệu thật vẫn nằm ở Oracle, PostgreSQL, Lakehouse, Warehouse hoặc hệ thống nguồn.
- **CMDB**
  - Quản lý hệ thống, máy chủ, ứng dụng, dịch vụ và configuration items của hạ tầng IT.
  - Catalog không thay thế được CMDB nhưng nên liên kết với nó.
- **Business Glossary**: chuẩn hóa và quản lý thuật ngữ nghiệp vụ.
- **Data Lineage**
  - Mô tả quan hệ và luồng biến đổi dữ liệu giữa các hệ thống.
  - *Upstream* trả lời "dữ liệu đến từ đâu"; *Downstream* trả lời "thay đổi sẽ ảnh hưởng tới đâu".
  - Có hai mức chi tiết: *Table-level* và *Column-level*. Column-level là cơ sở cho impact analysis chính xác.
- **Data Ownership**: xác định ai có quyền quyết định cuối cùng về ý nghĩa và tính hợp lệ của dữ liệu.
- **Classification, Access Governance và Lifecycle Governance**
  - Phân loại dữ liệu theo mức độ nhạy cảm.
  - Gắn chính sách truy cập với cơ chế thực thi (enforcement).
  - Quản lý vòng đời từ lúc tạo đến lúc hủy.
- **Governance & Metadata Plane**: lớp dùng chung để quản lý metadata, chính sách và quan hệ quản trị cho nhiều hệ thống.
- **Governance by Design**: governance có mặt ngay từ lúc thiết kế dataset.
- **Orphan dataset**: dataset không còn owner hoặc không còn ai quản lý.

**4. Kiến trúc, pattern & quy trình**
- **Kiến trúc logic 3 lớp**
  - Các thành phần có thể phân tán trên nhiều sản phẩm, không nhất thiết là 3 hệ thống vật lý riêng.
  - `DATA CONSUMERS (BI/Analytics/AI/APIs)` dùng dữ liệu từ `DATA PLATFORM: Sources → Ingestion → Lakehouse → Serving` (gồm Pipelines và Data Models).
  - Bên dưới là `GOVERNANCE & METADATA PLANE`: Metadata Catalog, Business Glossary, Data Lineage, Ownership Registry, Data Classification, Policy Definitions, Data Lifecycle, Governance Workflows.
  - Dưới cùng là `CONTROL & ENFORCEMENT`: IAM/RBAC/ABAC; access policies ở database và engine; Data Masking, Auditing và Retention Controls.
- **Metadata Collection**
  - Luồng: `Oracle/PostgreSQL/SQL Server + Airflow/Spark/dbt/Kafka + Lakehouse/Warehouse + BI/Analytics → Metadata Ingestion → Central Metadata Store`.
  - Có thể chạy theo lịch, theo sự kiện, hoặc gắn vào quá trình deploy pipeline. Khi deploy, pipeline tự đăng ký dataset, schema, technical owner, source dependencies, classification và quan hệ với pipeline khác.
  - Technical metadata thu thập tự động được; business definition và ownership vẫn cần con người xác nhận.
- **Governance by Design**
  - Luồng: `New Dataset Request → Define Business Purpose → Assign Ownership → Define Schema & Classification → Review Access Requirements → Build Pipeline → Validate Metadata & Policy → Publish to Catalog → Operate & Review`.
  - Nhờ vậy governance trở thành một phần của Data Engineering lifecycle, thay vì việc viết tài liệu làm sau cùng.
- **Lineage end-to-end**: `Oracle Trading Core → TRADE_HISTORY →(CDC/Ingestion) bronze.trade_events →(Clean/Deduplicate) silver.trades →(Business Transformation) gold.fact_trade →(Semantic Model) Trading Metrics → Trading Dashboard`.
- **Cách thu thập lineage**
  - Nguồn lineage: SQL parsing, tích hợp với pipeline, execution metadata, API.
  - Kiến trúc nên là **Automated Lineage + Explicit Lineage Registration + Metadata Validation**.
  - Lineage phải hiển thị độ đầy đủ và phạm vi bao phủ, để không tạo cảm giác đã truy vết hết mọi phụ thuộc.
- **Liên kết CMDB ↔ Catalog**
  - Chuỗi: `Application Trading Core → Database Oracle Trading DB → Dataset TRADE_HISTORY → Pipeline trading_ingestion → silver.trades → Data Product Customer Trading Analytics`.
  - Liên kết này cho phép truy vết từ hạ tầng đến dữ liệu nghiệp vụ.
- **Mô hình ownership**: mỗi dataset có Accountable Team (kèm Assigned Data Owner), Technical Team (kèm Technical Contact) và Governance Steward.
- **Vòng đời dữ liệu**: `Create/Ingest → Classify → Store & Process → Use & Share → Retain/Archive → Delete/Dispose`.
- **Operating model gồm 3 nhóm**
  - *Central Governance Function*: chuẩn metadata, chuẩn classification, quy tắc ownership, policies, yêu cầu compliance, giải quyết tranh chấp giữa các domain.
  - *Data Domain Teams*: business definitions, business ownership, stewardship, phê duyệt mục đích sử dụng, giải quyết xung đột định nghĩa.
  - *Data Platform Team*: metadata ingestion; tích hợp catalog, lineage và policy enforcement; platform APIs; automation; audit và năng lực vận hành.
  - Mô hình này không bắt buộc phải theo Data Mesh. Ngay cả một Centralized Data Platform vẫn cần tách business accountability khỏi platform responsibility.
- **Kiến trúc trong case study**
  - Luồng: `Trading DB / CRM DB / Margin DB → Ingestion/CDC → Bronze → Silver → Gold → Semantic Layer → BI/Reporting/AI`.
  - Governance capabilities nằm **xuyên suốt (cross-cutting)** toàn bộ luồng, không phải một pipeline riêng chạy sau Gold.

**5. Framework ra quyết định & so sánh**

Bảng 1 – Các năng lực của Data Governance:

| Capability | Vai trò |
|---|---|
| Data Ownership | Xác định ai chịu trách nhiệm với dữ liệu |
| Metadata Management | Quản lý thông tin mô tả dữ liệu |
| Data Catalog | Khám phá và hiểu data assets |
| Business Glossary | Chuẩn hóa thuật ngữ nghiệp vụ |
| Data Lineage | Theo dõi nguồn gốc và luồng biến đổi |
| Data Classification | Phân loại theo mức độ nhạy cảm |
| Data Access Governance | Quản trị chính sách truy cập và sử dụng |
| Data Lifecycle Governance | Quản lý dữ liệu từ khi tạo đến khi lưu trữ hoặc loại bỏ |

Bảng 3 – Business Glossary so với Semantic Layer:

| Business Glossary | Semantic Layer |
|---|---|
| Chuẩn hóa thuật ngữ nghiệp vụ | Chuẩn hóa mô hình phân tích và cách tính metric |
| Xác định định nghĩa được phê duyệt | Biểu diễn logic tính toán của metric |
| Gắn với business owner | Gắn với dimensions, measures, semantic models |
| Hỗ trợ discovery và governance | Hỗ trợ nhất quán khi truy vấn và phân tích |

Glossary định nghĩa *ý nghĩa*; Semantic Layer biến ý nghĩa đó thành mô hình truy vấn nhất quán. Vì vậy hai thứ nên được liên kết với Metrics Governance, không quản lý tách rời.

Bảng 4 – Vai trò trong ownership. Tên gọi có thể khác giữa các tổ chức; điều quan trọng là rõ ai chịu trách nhiệm cho từng quyết định, không phải có thật nhiều vai trò.

| Vai trò | Trách nhiệm |
|---|---|
| Data Owner | Chịu trách nhiệm dữ liệu trong phạm vi nghiệp vụ; phê duyệt định nghĩa và yêu cầu sử dụng |
| Data Steward | Duy trì business metadata, phối hợp xử lý vấn đề dữ liệu, thực thi quy trình governance |
| Technical Owner | Triển khai và vận hành thành phần kỹ thuật |
| Data Custodian | Quản lý lưu trữ và biện pháp bảo vệ theo chính sách |
| Data Consumer | Dùng dữ liệu theo quyền hạn và mục đích được phê duyệt |
| Governance Function | Xây chuẩn chung, giám sát tuân thủ, giải quyết xung đột chính sách |

Bảng 5 – Phân loại dữ liệu. Tác giả nói rõ đây là ví dụ minh họa, không phải chuẩn bắt buộc.

| Classification | Ví dụ | Yêu cầu quản trị |
|---|---|---|
| Public | Thông tin sản phẩm công khai | Cho phép chia sẻ theo chính sách |
| Internal | Operational statistics | Giới hạn sử dụng nội bộ |
| Confidential | Customer trading activity | Phân quyền theo vai trò và mục đích |
| Restricted | Thông tin định danh, dữ liệu đặc biệt nhạy cảm | Kiểm soát chặt, ghi audit, hạn chế truy cập |

Các so sánh khác trong bài:
- **Upstream so với Downstream lineage**
  - Upstream dùng để điều tra khi `gold.fact_trade` sai: `silver.trades` có đúng không? Transformation có đổi logic không? CDC có thiếu dữ liệu không? Nguồn có đổi schema hoặc logic không?
  - Downstream dùng để đánh giá tác động trước khi thay đổi.
- **Table-level so với Column-level**
  - Table-level: `source.orders → silver.orders → gold.fact_orders`.
  - Column-level: biết được `gold.fact_orders.amount` (tính bằng `quantity * price`) phụ thuộc vào `quantity` và `price`.
- **Gắn ownership cho team hay cá nhân?** Nên ưu tiên team/domain và chỉ định thêm một cá nhân phối hợp, để ownership không mất khi nhân sự chuyển việc hoặc nghỉ.
- **Business Owner so với DBA/DE**
  - DBA lo availability, performance, backup và recovery.
  - DE lo pipeline, transformation và processing.
  - Cả hai đều không nhất thiết có quyền quyết định định nghĩa của một metric.
- **Gắn nhãn classification so với thực thi (enforcement)**
  - Nhãn chỉ mô tả mức độ nhạy cảm và chính sách mong muốn.
  - Thực thi cần IAM/RBAC, ABAC, row-level và column-level security, masking/tokenization, encryption, audit logging.
  - Điểm thực thi có thể là database, SQL engine, semantic layer, data API hoặc một policy enforcement component.
- **Tự động so với thủ công**: tự động hóa các kiểm tra xác định được bằng chính sách; con người chỉ can thiệp khi có ngoại lệ hoặc cần quyết định nghiệp vụ.

**6. Best practices / nguyên tắc thiết kế**
- Áp dụng Governance by Design: đưa governance vào Data Engineering lifecycle và vào CI/CD.
- Coi metadata là thứ "sống", cập nhật theo vòng đời; tích hợp việc đăng ký metadata vào quá trình deploy pipeline.
- Định nghĩa nghiệp vụ phải do business stakeholders có thẩm quyền quyết định, sau đó mới chuyển thành data model hoặc metric logic.
  - Định nghĩa trong glossary ở production phải làm rõ múi giờ, thời điểm chốt dữ liệu, trạng thái giao dịch đủ điều kiện và quy tắc loại trừ.
  - Metric ở production cần các quy tắc đã được phê duyệt: ngày giao dịch, phạm vi thị trường, điều chỉnh sau giao dịch, loại giao dịch được tính.
- Liên kết Business Glossary với Semantic Layer và Metrics Governance.
- Xây lineage bằng cả tự động, đăng ký tường minh và kiểm chứng; công bố mức coverage; dùng downstream/column-level lineage để làm impact analysis và đưa bước này vào change management.
- Gắn ownership ở cấp team/domain. Định nghĩa sẵn quy trình cho các tình huống: đổi owner, dataset bị bỏ rơi, hai domain tranh chấp ownership, xảy ra data incident.
- Classification phải nối với cơ chế enforcement; không coi Catalog là nơi duy nhất làm bảo mật.
- Retention phải xác định theo quy định pháp lý, yêu cầu nghiệp vụ và chính sách nội bộ cho từng loại dữ liệu (dữ liệu giao dịch chứng khoán khác log ứng dụng). Không áp một con số chung cho cả platform.
- Lifecycle phải bao trùm mọi bản sao: raw files, historical partitions, backups, materialized views, replicas, derived datasets, exported reports.
- Đo governance bằng KPI và phân tích theo mức độ quan trọng của dataset. Ví dụ, dataset phục vụ regulatory reporting cần ưu tiên hơn một bảng tạm không còn consumer.
- Triển khai theo từng giai đoạn, ưu tiên khả năng sử dụng thực tế hơn số lượng metadata thu thập được.
- Metadata mapping chỉ mô tả những trường cần đối chiếu. Logic đối chiếu phải dựa trên quan hệ nghiệp vụ, master data và quy tắc có hiệu lực theo thời gian.
- Owner của data product tổng hợp có thể khác owner của từng source dataset.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Coi governance là việc làm sau cùng, là việc viết tài liệu. Hoặc đồng nhất governance với việc "triển khai Catalog, viết nhiều tài liệu, thêm thủ tục phê duyệt", để rồi governance chỉ tồn tại trên giấy.
- Có Catalog và tự động thu thập metadata cho hàng nghìn bảng nhưng vẫn chưa có governance hiệu quả.
- Cùng một thuật ngữ, nhiều cách hiểu. Ví dụ "Active Customer":
  - Trading hiểu là có giao dịch trong 30 ngày gần nhất.
  - Customer Service hiểu là có tài khoản đang hoạt động.
  - Finance hiểu là có phát sinh doanh thu trong kỳ.
- Data Engineer tự chọn một định nghĩa khi Trading và Finance hiểu khác nhau về `Net Trading Revenue`.
- "Ai cũng dùng, không ai chịu trách nhiệm". Khi dashboard doanh thu sai:
  - BI nói SQL đúng.
  - DE nói pipeline chạy thành công.
  - DBA nói database bình thường.
  - Business nói dữ liệu sai nghiệp vụ.
- Gắn ownership cho cá nhân, nên ownership mất khi người đó rời đi. Hoặc chỉ gắn owner mà không có quy trình đi kèm.
- Tin rằng lineage đầy đủ 100%. Các điểm mù gồm: dynamic SQL, stored procedures phức tạp, transformation nằm trong application code, copy dữ liệu thủ công, mapping xử lý ngoài platform, công cụ không xuất metadata.
- Tin rằng lineage tự đánh giá được rủi ro nghiệp vụ của một thay đổi. Risk Owner và Technical Owner vẫn phải xác nhận.
- Gắn nhãn `Restricted` rồi coi như dữ liệu đã được bảo vệ.
- Nghĩ rằng xóa khỏi bảng production là đã xóa khỏi toàn bộ hệ sinh thái.
- Mặc định các khóa khách hàng ở nhiều hệ thống là tương đương hoặc quan hệ 1-1, dẫn đến JOIN sai nghiệp vụ.
- Mặc định dữ liệu tổng hợp luôn an toàn để công khai. Báo cáo có ít bản ghi hoặc lọc quá chi tiết vẫn có thể làm lộ thông tin khách hàng.
- Cố quản trị toàn bộ data estate ngay trong lần triển khai đầu; đo KPI chỉ theo tổng số lượng.
- Mọi pipeline chạy thành công nhưng ownership coverage chỉ đạt 20%: đây là rủi ro quản trị rõ ràng.

**8. Ví dụ minh họa**
- **Bảng 2 – dữ liệu mẫu của `fact_trade`.** Chỉ nhìn các bản ghi này thì chưa đủ để hiểu và quản trị bảng.

  | trade_id | customer_id | symbol | quantity | amount |
  |---|---|---|---|---|
  | T001 | C001 | FPT | 100 | 10,000,000 |
  | T002 | C002 | SSI | 200 | 6,000,000 |

- **Metadata YAML của `fact_trade`**:
  - Domain `securities_trading`, mô tả là bảng fact giao dịch.
  - Business owner là Trading Operations, technical owner là Data Engineering.
  - Nguồn là Trading Core; lưu ở Lakehouse, layer Gold.
  - Classification Internal; PK là `trade_id`.
  - Refresh theo kiểu Incremental, tần suất kỳ vọng 5 phút.
  - Consumers: Trading Dashboard, Revenue Analytics, Risk Reporting.
- **Tìm "Customer Trading Activity" trên Catalog** trả về:
  - Dataset `gold.fact_customer_trading`, domain Securities Trading.
  - Business owner Trading Operations, technical owner Data Engineering.
  - Refresh mỗi 5 phút, classification Confidential.
  - Related metrics: Trading Volume, Trading Value.
  - Downstream: Trading Dashboard, Revenue Analytics.
- **Thuật ngữ "Active Trading Customer"** (minh họa):
  - Định nghĩa: khách hàng có ít nhất 1 giao dịch đủ điều kiện đã khớp trong 30 ngày gần nhất.
  - Owner: Trading Operations.
  - Datasets liên quan: `fact_trade`, `dim_customer`. Metric liên quan: `active_trading_customers_30d`.
- **Trading Value**:
  - Glossary định nghĩa: tổng giá trị khớp lệnh hợp lệ trong một khoảng thời gian.
  - Semantic layer (SQL minh họa): tính `SUM(trade_amount)` trên `gold.fact_trade` với điều kiện `trade_status='MATCHED'`.
- **Downstream lineage khi Oracle đổi cách tính `trade_amount`**: `TRADE_HISTORY.trade_amount → silver.trades.trade_amount → gold.fact_trade.trading_value`, từ đó rẽ thành hai nhánh: Trading Value Metric → Executive Dashboard, và Revenue Analytics.
- **Ownership của `gold.fact_trade`**:
  - Business owner: Trading Operations.
  - Steward: Trading Data Management.
  - Technical owner: Data Engineering.
  - Platform custodian: Data Platform Operations.
  - Consumers: Risk Analytics, Finance, BI.
- **`customer_profile`**:
  - Classification Restricted; các trường nhạy cảm là `customer_name`, `identity_number`, `phone_number`.
  - Approved roles: CustomerOperations, Compliance.
  - Ví dụ thực thi: Finance được xem tổng doanh thu nhưng không được xem định danh từng khách hàng.
- **KPI**: platform có 2.000 datasets nhưng chỉ 400 có owner, tức ownership coverage chỉ đạt 20%.
- **Case study Securities Data Platform**:
  - *Nguồn*: Trading Core, Customer Management, Account Management, Margin/Loan System, Market Data, General Ledger, Risk Management.
  - *Mục đích sử dụng trên Lakehouse*: Trading Analytics, Customer 360, Margin Risk, Portfolio Analytics, Financial Reporting, Management Dashboards.
  - *Vấn đề (Bảng 7)*: mỗi hệ thống có trường khách hàng riêng. Các trường này có liên quan nhưng không được mặc định là cùng thực thể hay quan hệ 1-1.

    | Hệ thống | Trường khách hàng |
    |---|---|
    | Trading Core | `CUSTODYCD` |
    | CRM | `CUSTOMER_ID` |
    | Account Management | `CLIENT_ID` |
    | Margin System | `CUSTOMER_CODE` |

  - *Bước 1 – chuẩn hóa Glossary*, do Business Owner phê duyệt:
    - Customer: thực thể khách hàng theo mô hình dữ liệu chuẩn của doanh nghiệp.
    - Trading Account: tài khoản giao dịch chứng khoán.
    - Custody Account: tài khoản lưu ký.
    - Customer Portfolio: tập vị thế/tài sản của khách hàng trong một phạm vi và thời điểm xác định.
  - *Bước 2 – Metadata Mapping*:
    - Business entity Customer được ánh xạ tới CRM.`CUSTOMER_ID`, Trading Core.`CUSTODYCD` và Account Management.`CLIENT_ID`.
    - Mapping rules: ownership thuộc Customer Data Domain, `reconciliation_required: true`, `effective_dating_required: true`.
    - Mapping chỉ mô tả các trường cần đối chiếu, không khẳng định các khóa là tương đương.
  - *Bước 3 – Ownership (Bảng 8)*:

    | Dataset | Business Owner | Technical Owner |
    |---|---|---|
    | Customer Master | Customer Operations | Data Engineering |
    | Trading Transactions | Trading Operations | Data Engineering |
    | Margin Exposure | Risk / Margin Business | Data Engineering |
    | Market Prices | Market Data Function | Data Engineering |
    | Portfolio Analytics | Portfolio / Investment Business | Analytics Engineering |

  - *Bước 4 – Lineage của `margin_exposure_dashboard`*:
    - Luồng: Margin Core (Loan Balance, Collateral Information) vào Silver; Market Data → Market Prices → Exposure Calculation; sau đó → Gold Margin Exposure → Risk Metrics → Dashboard.
    - Khi market prices đổi cách cung cấp, lineage chỉ ra các thành phần cần đánh giá. Tuy nhiên Risk Owner và Technical Owner vẫn phải xác nhận logic, điều kiện dữ liệu và phạm vi ảnh hưởng.
  - *Bước 5 – Classification*:
    - Market Reference Data: Public hoặc Internal, tùy nguồn và license.
    - Customer Trading History: Confidential.
    - Customer Identity Information: Restricted.
    - Aggregated Trading Metrics: Internal hoặc Confidential, tùy mức độ tổng hợp và khả năng nhận diện khách hàng.
  - *Bước 6*: kết nối governance với platform theo luồng cross-cutting ở mục 4.
  - *Kết quả mong muốn*:
    - Business Analyst tìm dữ liệu margin exposure qua 7 bước: tìm trên Catalog → đọc định nghĩa → xác định Business Owner → xem Lineage → xác định mức nhạy cảm → gửi access request → dùng dataset/data product đã được phê duyệt.
    - Data Engineer xem lineage và các phụ thuộc downstream trước khi đổi source schema.
    - Khi có incident, các team xác định nhanh hơn ai chịu trách nhiệm và phạm vi ảnh hưởng.
- [Ghi chú] Bài này không dùng các bảng ORDERS/CASH_BALANCE/POSITION. Kịch bản chứng khoán xoay quanh TRADE_HISTORY/`fact_trade`, các khóa khách hàng và margin exposure; `source.orders` chỉ xuất hiện trong ví dụ lineage.

**9. Công nghệ/công cụ được nhắc tới**
- **OpenMetadata**: catalog, metadata ingestion, ownership, glossary, lineage.
- **DataHub**: metadata discovery, governance, ownership, lineage.
- **Microsoft Purview**: catalog và governance trong hệ sinh thái Microsoft.
- **CMDB**: quản lý ứng dụng, hạ tầng và configuration items; nên liên kết với Catalog.
- **Oracle, PostgreSQL, SQL Server**: nơi dữ liệu thật nằm, đồng thời là nguồn metadata.
- **Airflow, Spark, dbt, Kafka**: nguồn pipeline metadata để thu thập metadata và lineage.
- **Lakehouse/Warehouse, BI/Analytics**: nguồn metadata và lớp lưu trữ/phục vụ dữ liệu.
- **Semantic Layer**: hiện thực hóa định nghĩa trong glossary thành logic tính metric.
- **IAM/RBAC/ABAC, row/column-level security, masking/tokenization, encryption, audit logging**: lớp enforcement.
- **CI/CD**: nơi đặt các governance checks (Phase 5).
- Tài liệu tham khảo: Purview (Glossary, Lineage); DataHub (Metadata Management & Governance, Lineage); OpenMetadata (Ownership, Lineage).

**10. Checklist / câu hỏi thiết kế**
- **Governance Workflow 10 bước** (ví dụ dataset `customer_portfolio_summary`). Không phải bước nào cũng cần duyệt thủ công.
  1. DE đăng ký dataset.
  2. Business Owner xác nhận mục đích.
  3. Data Steward kiểm tra định nghĩa.
  4. Phân loại dữ liệu.
  5. Technical Owner cấu hình pipeline.
  6. Áp dụng Security Policy.
  7. Cập nhật Metadata & Lineage.
  8. Công bố dataset trên Catalog.
  9. Consumer gửi access request.
  10. Review định kỳ.
- **Governance KPIs (Bảng 6)**:

  | KPI | Ý nghĩa |
  |---|---|
  | Ownership Coverage | Tỷ lệ datasets có owner hợp lệ |
  | Metadata Completeness | Tỷ lệ metadata fields bắt buộc đã điền |
  | Classification Coverage | Tỷ lệ datasets đã phân loại |
  | Lineage Coverage | Tỷ lệ assets quan trọng có lineage đạt yêu cầu |
  | Glossary Adoption | Tỷ lệ business assets liên kết với thuật ngữ đã phê duyệt |
  | Access Review Compliance | Tỷ lệ quyền truy cập được rà soát theo chính sách |
  | Orphan Dataset Count | Số datasets không còn owner hoặc không được quản lý |
  | Governance Exception Aging | Thời gian các ngoại lệ governance chưa được xử lý |

- **Lộ trình 5 giai đoạn**:
  1. *Data Discovery*: kết nối các hệ thống quan trọng, thu thập technical metadata, lập inventory và Catalog cơ bản.
  2. *Ownership & Classification*: xác định critical datasets, gắn business owner và technical owner, đặt nền tảng classification và glossary.
  3. *Lineage & Impact Analysis*: kết nối pipeline metadata, xây end-to-end lineage cho các luồng quan trọng, đưa impact analysis vào change management.
  4. *Policy Integration*: nối governance metadata với access control; quản lý access review, retention, audit; tự động hóa policy validation ở những điểm phù hợp.
  5. *Continuous Governance*: theo dõi Governance KPIs, metadata freshness, ownership review, governance workflows; liên kết với Data Quality và Observability; đưa governance checks vào CI/CD.

  Lộ trình này ưu tiên khả năng dùng thực tế hơn số lượng metadata thu thập được.
- **Metadata vòng đời cho mỗi dataset**: retention period, retention trigger, archival policy, deletion policy, legal hold, backup retention, approved purposes of processing, evidence of policy execution.
- **7 câu hỏi enterprise ở phần kết**:
  - Doanh nghiệp thực sự đang có những dữ liệu nào?
  - Dữ liệu đó mang ý nghĩa nghiệp vụ gì?
  - Ai chịu trách nhiệm quản lý?
  - Dữ liệu đến từ đâu?
  - Thay đổi một dataset sẽ ảnh hưởng đến đâu?
  - Ai được quyền sử dụng?
  - Dữ liệu được lưu giữ và loại bỏ thế nào?

**11. Kết luận & key takeaways**
- **Câu hỏi quản trị quan trọng ngang câu hỏi kỹ thuật.** Ở quy mô enterprise, các câu hỏi về ý nghĩa, trách nhiệm, nguồn gốc, tác động, quyền dùng và vòng đời của dữ liệu quan trọng không kém các câu hỏi kỹ thuật:
  - Ingest dữ liệu như thế nào?
  - Dùng Data Lake hay Lakehouse?
  - Điều phối pipeline bằng gì?
  - Dùng Spark, SQL hay Streaming?
  - Mô hình hóa dữ liệu ra sao?
- **Governance không phải là công cụ hay thủ tục.** Nó không chỉ là triển khai Catalog, viết thêm tài liệu hay thêm bước phê duyệt. Governance phải được hiện thực thành metadata, ownership, policies, workflows và cơ chế kiểm soát.
- **Metadata là nền móng.** Metadata gồm 4 nhóm. Các năng lực Catalog, Glossary, Lineage, Ownership, Classification, Access và Lifecycle liên kết với nhau trong một Governance & Metadata Plane áp dụng xuyên suốt platform.
- **Ownership gắn với team/domain.** Business là bên quyết định định nghĩa nghiệp vụ, không phải DE hay DBA.
- **Không ngộ nhận về bảo vệ dữ liệu:**
  - Nhãn phân loại phải đi kèm cơ chế enforcement.
  - Lineage không bao giờ đầy đủ 100%.
  - Dữ liệu tổng hợp chưa chắc đã an toàn để công khai.
- **Triển khai và đo lường.** Triển khai theo 5 giai đoạn, đo bằng KPI có trọng số theo mức độ quan trọng. Khi đó platform không chỉ xử lý dữ liệu mà còn giải thích, truy vết và kiểm soát được dữ liệu.
- Trích dẫn: *"Governance là cách doanh nghiệp đưa ra quyết định và thực thi trách nhiệm đối với dữ liệu."*
- Trích dẫn: *"Data Platform giúp doanh nghiệp sử dụng dữ liệu. Data Governance giúp doanh nghiệp biết dữ liệu đó là gì, ai chịu trách nhiệm…"* Câu gốc còn tiếp: dữ liệu có thể tin cậy và được dùng trong phạm vi nào.

**12. Liên kết với các bài khác**
- **Bài 10** (Semantic Layer & Metrics Governance): là điểm xuất phát của bài. Bài 11 so sánh Glossary với Semantic Layer và đề xuất liên kết Glossary với Metrics Governance.
- **Bài 6** (Data Quality & Data Contracts): Bài 11 phân biệt DQ với Governance. Giai đoạn 5 của lộ trình liên kết hai năng lực này.
- **Bài 13** (Data Observability): operational metadata là đầu vào của Observability. Giai đoạn 5 cũng liên kết với Observability.
- **Bài 12**: được giới thiệu ở cuối bài, với các câu hỏi về lỗi giữa chừng, gửi lặp, CDC replay và backfill lịch sử.
- Bài dùng lại Medallion (Bronze/Silver/Gold), CDC/Ingestion và Semantic Layer từ các bài trước.
- Bài có nhắc Data Mesh (nói rõ là không bắt buộc) nhưng không chỉ số bài.

---

## Bài 12: Modern Data Platform – Bài 12: Incremental Processing, Idempotency & Recovery – Thiết kế Pipeline có khả năng phục hồi
*Subtitle: Làm thế nào để Data Pipeline có thể retry, replay, backfill và khôi phục sau sự cố mà vẫn đảm bảo dữ liệu chính xác, nhất quán? Đăng ngày 2026-10-12. Bài có 3 bảng dạng ảnh (đã xem đủ) và 1 bảng bị làm phẳng trong text (đã dựng lại).*

Mục lục (H2): 1. Incremental Processing – Vì sao không thể xử lý lại toàn bộ dữ liệu? | 2. Processing Semantics – At-Most-Once, At-Least-Once và Exactly-Once | 3. Idempotency – Tại sao chạy Pipeline nhiều lần vẫn phải cho kết quả đúng? | 4. Checkpoint, Watermark & Processing State – Pipeline nhớ mình đã xử lý đến đâu? | 5. Retry & Failure Handling – Khi Pipeline thất bại thì phải làm gì? | 6. Replay & Backfill – Làm thế nào để xử lý lại dữ liệu lịch sử? | 7. Late-Arriving Data, Out-of-Order Events & Historical Corrections | 8. Recovery Architecture – Thiết kế một Pipeline có khả năng tự phục hồi | 9. Case Study – Recovery cho Securities Trading Data Pipeline | 10. Production Design Principles – Những nguyên tắc cần có trong Data Pipeline | Kết luận

**1. Bối cảnh & vấn đề mở đầu**

Tác giả điểm lại những gì đã xây ở các bài trước: Ingestion, Lakehouse & Medallion, Orchestration, Data Quality & Data Contracts, CDC, Analytical Data Modeling. Khi vận hành thật, câu hỏi then chốt là: pipeline thất bại giữa chừng thì chuyện gì xảy ra?

Kịch bản: platform xử lý 10 triệu giao dịch chứng khoán mỗi ngày theo luồng `Trading Core → CDC/Incremental Ingestion → Bronze → Silver → Gold → Trading Dashboard`.

Các sự cố có thể gặp:
- Dữ liệu đã ghi vào Lakehouse nhưng trạng thái hoàn thành chưa kịp cập nhật.
- CDC consumer nhận cùng một event nhiều lần.
- Worker bị restart giữa lúc xử lý.
- Pipeline xử lý được 80% rồi thất bại.
- Một giao dịch được cập nhật sau khi dữ liệu của ngày đã được tổng hợp.
- Cần chạy lại 30 ngày vì đổi business logic.
- Source gửi dữ liệu chậm hoặc sai thứ tự.
- Hai pipeline cùng xử lý một partition.

Với mô hình đơn giản `Read → Transform → Write → Success`, rất khó đảm bảo dữ liệu đúng khi những sự cố này xảy ra.

**2. Luận điểm cốt lõi**
- **Đây là nguyên tắc kiến trúc, không phải tính năng phụ.** Incremental Processing, Idempotency, Checkpointing, Retry, Replay, Backfill và Recovery giúp dữ liệu nhất quán suốt vòng đời xử lý. Chúng không chỉ là kỹ thuật xử lý lỗi hay chức năng phụ của orchestrator.
- **Công thức thực tế cho Lakehouse** là **At-Least-Once Delivery + Idempotent Processing + Transactional Sink**: chấp nhận một phần xử lý có thể chạy nhiều lần, miễn kết quả cuối vẫn đúng.
- **Định nghĩa pipeline đáng tin cậy:** không phải pipeline không bao giờ lỗi, mà là pipeline lỗi, chạy lại và phục hồi được mà không làm sai dữ liệu.

**3. Khái niệm chính**
- **Full Processing / Full Refresh**
  - Đọc toàn bộ nguồn (ví dụ `SELECT * FROM trading_transactions`) rồi ghi đè toàn bộ bảng đích.
  - Ưu điểm: dễ hiểu, ít phải quản lý state, dễ tái tạo dữ liệu.
  - Khi dữ liệu lên tới hàng trăm triệu hoặc hàng tỷ bản ghi, cách này bộc lộ nhược điểm:
    - Tăng tải cho source DB và tốn compute.
    - Chạy lâu, tốn thêm chi phí lưu trữ trung gian.
    - Chậm cung cấp dữ liệu mới.
    - Rủi ro cao khi ghi đè dataset lớn.
- **Incremental Processing**
  - Chỉ xử lý phần dữ liệu mới hoặc đã thay đổi kể từ lần chạy trước.
  - Bản chất là xác định đúng phạm vi dữ liệu cần cập nhật để kết quả cuối nhất quán, chứ không chỉ lọc các bản ghi có `updated_at` mới hơn.
  - Một thay đổi ở nguồn có thể buộc nhiều bản ghi hoặc nhiều aggregate phải tính lại.
- **Processing/delivery semantics**
  - *At-Most-Once*: mỗi event được xử lý tối đa một lần; khi có sự cố, event có thể bị mất.
  - *At-Least-Once*: mỗi event được xử lý ít nhất một lần, với điều kiện nguồn và cơ chế recovery đáp ứng yêu cầu; có thể sinh trùng lặp.
  - *Exactly-Once*: xét về hiệu ứng, mỗi event chỉ tác động lên kết quả cuối đúng một lần, kể cả khi bị đọc hoặc xử lý lại.
  - Cần tách ba khái niệm: exactly-once delivery, exactly-once state consistency và end-to-end exactly-once effects. Engine đảm bảo exactly-once cho internal state không có nghĩa hệ thống bên ngoài cũng được đảm bảo.
- **Idempotency**
  - Chạy cùng một thao tác nhiều lần, với cùng input và cùng điều kiện, cho ra cùng trạng thái như khi chạy một lần: `f(f(x)) = f(x)`.
  - Phải xét toàn bộ tác động lên dữ liệu, không chỉ câu lệnh transformation.
  - Mục tiêu là chạy lại an toàn, không phải tránh chạy lại.
- **Business Key, Event ID, Event Version/Sequence**
  - Business Key xác định đối tượng nghiệp vụ.
  - Event ID xác định một sự kiện thay đổi.
  - Version/Sequence xác định thứ tự các thay đổi.
  - Phải xác định đúng identity và ordering semantics trước khi deduplicate.
- **Watermark trong incremental batch**: là mốc tiến độ xử lý (`last_committed_watermark`). Watermark chỉ được tiến lên sau khi kết quả đã ghi thành công và được xác nhận.
- **Checkpoint trong streaming**: gồm source position, operator state, aggregation state và processing progress. Cách recovery cụ thể phụ thuộc framework và connector.
- **Event-time watermark khác với incremental cursor**
  - Event-time watermark cho biết event time đã tiến tới đâu, dùng để quyết định khi nào xử lý hoặc chốt một window theo chính sách lateness.
  - Source checkpoint/offset dùng để khôi phục vị trí đọc và processing state.
  - Hai loại state này phục vụ hai mục đích khác nhau.
- **Retry và Recovery**
  - Retry là chạy lại một phần công việc.
  - Recovery là đưa hệ thống về trạng thái dữ liệu nhất quán rồi tiếp tục hoạt động.
- **Execution contract**: mỗi task cần có:
  - Input được xác định rõ.
  - Output nhận diện và kiểm tra được.
  - Quy tắc commit.
  - Retry policy và recovery strategy.
  - Cơ chế chống ghi xung đột đồng thời.
- **Replay và Backfill**
  - Replay là chạy lại quá trình xử lý từ dữ liệu hoặc event đã lưu giữ.
  - Backfill là xử lý dữ liệu cho một khoảng thời gian hoặc partition trong quá khứ. Mục đích có thể là bù ngày bị thiếu, áp dụng logic mới, hoặc tái tạo historical model.
- **Event Time và Processing Time**
  - Event Time là thời điểm sự kiện thực sự xảy ra theo nguồn hoặc theo định nghĩa nghiệp vụ.
  - Processing Time là thời điểm platform xử lý sự kiện.
  - Ngoài ra còn có Transaction time và Business effective date.
- **Late-arriving data, Out-of-order events, Historical corrections**: lần lượt là dữ liệu đến trễ, dữ liệu đến sai thứ tự, và điều chỉnh cho kỳ đã qua.
- **Processing Run Registry**: bảng theo dõi các lần chạy (execution attempts).
- **Data Reconciliation**: đối chiếu output với kết quả kỳ vọng sau khi recovery.
- **RPO (Recovery Point Objective)**: lượng dữ liệu tối đa được phép mất, tính theo thời điểm khôi phục đã cam kết.
- **RTO (Recovery Time Objective)**: thời gian tối đa mục tiêu để khôi phục dịch vụ.
- **Data freshness SLO**: mục tiêu độ tươi của từng data product, khác với RPO/RTO của platform.

**4. Kiến trúc, pattern & quy trình**
- **Luồng incremental**: `Source Transaction →(CDC Event) Bronze →(Incremental MERGE) Silver →(Recalculate Affected Records) Gold`.
- **Nguồn gốc duplicate trong streaming**: với luồng `Kafka → Consumer → Transformation → Lakehouse`, consumer đã ghi xong nhưng restart trước khi xác nhận offset, nên nhận lại event cũ.
- **Pattern ghi idempotent**: tính lại aggregate từ dữ liệu chi tiết đã deduplicate rồi **gán** kết quả bằng `MERGE`, thay vì cộng dồn một delta không kiểm soát.
- **Incremental batch theo cửa sổ**: đọc với điều kiện `updated_at > lower_bound AND updated_at <= upper_bound`, và watermark chỉ được tiến lên sau khi commit.
- **Nguyên tắc commit**: không đánh dấu "đã xử lý" trước khi kết quả thực sự được commit.
  - Cập nhật progress trước, ghi lỗi sau → mất dữ liệu.
  - Commit kết quả trước, checkpoint chưa kịp cập nhật → dữ liệu bị xử lý lại. Trường hợp này kiểm soát được bằng idempotency hoặc transactional coordination.
  - Vì vậy thiết kế checkpoint phải đi cùng sink commit semantics.
- **Retry với exponential backoff**
  - Trình tự: Attempt 1 lỗi → chờ 10s → Attempt 2 lỗi → chờ 20s → Attempt 3 lỗi → chờ 40s → Attempt 4.
  - Mục đích: tránh nhiều pipeline cùng retry dồn dập khi nguồn đang gặp sự cố.
  - Nên bổ sung: giới hạn số lần retry, retry timeout, randomized jitter, rate limiting, circuit breaker và phân loại lỗi.
- **Task retry và pipeline retry**: với DAG `Extract → Transform → Load → Publish`, chỉ retry riêng Publish được khi output của các bước trước còn ổn định và tương thích. Nếu Transform tạo dữ liệu tạm rồi xóa đi, retry riêng Publish sẽ thất bại.
- **Replay**: luồng `Stored CDC Events → Replay Processor → Silver → Gold`. Bronze lưu raw immutable events kèm metadata về thứ tự, origin và thời điểm phát sinh. Nhờ đó có thể replay dài hạn mà không phụ thuộc hoàn toàn vào retention của message broker.
- **Partition-level reprocessing**: `gold.fact_trade` được partition theo `trade_date`. Partition nào sai thì tái tạo partition đó từ dữ liệu Silver đã được kiểm tra.
- **Xử lý historical correction**: `Incoming Changes → Identify Affected Business Keys → Identify Affected Partitions → Recompute/Merge → Update Gold`.
- **Recovery Architecture tham chiếu**
  - Luồng chính: `SOURCE → Ingestion/CDC → BRONZE (Replayable Data) → Processing Engine`, tách thành Processing State và Failure Handler (Retry/Quarantine), rồi hội tụ về `Transactional Write → SILVER → Incremental Modeling → GOLD`.
  - Các năng lực Recovery & Control: Checkpoint/Offset Store, Processing Run Registry, Idempotency/Deduplication, Replay & Backfill Controller, Data Reconciliation, Execution & Audit Metadata.
- **Processing Run Registry**
  - Bảng `pipeline_runs` gồm các cột `run_id` (PK), `pipeline_name`, `window_start`, `window_end`, `status`, `started_at`, `completed_at`, `error_message`.
  - Bảng này chỉ theo dõi các lần chạy. Nó không thay thế transactional checkpoint hay state backend của streaming engine.
  - State machine: `PENDING → RUNNING → (FAILED → RETRYING → RUNNING) → SUCCEEDED`.
  - Chỉ ghi `SUCCEEDED` khi output đã commit, dữ liệu đọc được, các kiểm tra bắt buộc đã xong và progress đã được xác nhận nhất quán.
- **Tách xử lý khỏi commit**: `Read → Transform → Validate → Commit Output → Confirm Progress`.
- **Quy trình backfill có kiểm soát**: `Approve Backfill Scope → Identify Logic Version → Select Source Snapshot → Create Backfill Execution → Process in Isolated Output → Validate Results → Publish/Atomic Switch → Record Audit & Lineage`.

**5. Framework ra quyết định & so sánh**

Bảng 1 – Incremental Ingestion và Incremental Processing:

| Incremental Ingestion | Incremental Processing |
|---|---|
| Thu thập dữ liệu mới/thay đổi từ nguồn | Xử lý phần dữ liệu bị ảnh hưởng bởi thay đổi |
| Dựa trên watermark, timestamp hoặc CDC | Dựa trên change set, partition, state hoặc dependency |
| Giảm lượng dữ liệu đọc từ source | Giảm lượng dữ liệu phải tính lại |
| Kết quả: dữ liệu được nạp vào platform | Kết quả: dữ liệu sau transformation được cập nhật |

Bảng 2 – Processing semantics:

| Semantics | Có thể mất dữ liệu? | Có thể xử lý lặp? | Phù hợp |
|---|---|---|---|
| At-Most-Once | Có | Thường không | Dữ liệu ít quan trọng |
| At-Least-Once | Không, nếu điều kiện đảm bảo được đáp ứng | Có | Phần lớn pipeline cần recovery |
| Exactly-Once Effects | Không, trong phạm vi được đảm bảo | Có thể chạy lại nhưng không tạo hiệu ứng lặp | Stateful processing, hệ thống yêu cầu consistency cao |

Ghi chú cho Bảng 2:
- At-Most-Once đơn giản nhưng không phù hợp với dữ liệu giao dịch tài chính.
- At-Least-Once thường được dùng cùng idempotency.
- Theo tài liệu Flink, exactly-once end-to-end cần source replay được và sink ghi transactional hoặc idempotent. Ví dụ phản chứng: stream processor có checkpoint nhất quán nhưng ghi ra external DB không hỗ trợ transactional/idempotent write thì vẫn sinh duplicate effects.

Bảng 3 – Các loại lỗi:

| Loại lỗi | Ví dụ | Hướng xử lý |
|---|---|---|
| Transient Failure | Network timeout | Retry với backoff |
| Resource Failure | Worker bị terminate | Restart, khôi phục state |
| Data Failure | Invalid schema | Quarantine, sửa rồi reprocess |
| Logic Failure | Transformation sai | Sửa logic rồi replay/backfill |
| Source Failure | Database unavailable | Chờ source phục hồi |
| Partial Commit | Chỉ ghi thành công một phần | Reconcile, idempotent recovery |
| Consistency Failure | Output sai hoặc thiếu | Rebuild phạm vi bị ảnh hưởng |

Bảng Replay và Backfill (dựng lại từ text bị làm phẳng). Tác giả kết luận kiến trúc tốt cần hỗ trợ cả hai.

| Replay | Backfill |
|---|---|
| Chạy lại event/data stream đã ghi nhận | Bổ sung hoặc tính lại một phạm vi lịch sử |
| Dùng source offsets hoặc stored events | Xác định theo thời gian, partition hoặc business scope |
| Quan trọng trong event-driven processing | Phổ biến trong batch/analytical processing |
| Có thể khôi phục streaming state | Có thể sửa historical aggregates |

Các tiêu chí quyết định khác:
- **Chọn cursor**: `updated_at` không phải lúc nào cũng an toàn, vì nhiều bản ghi có thể trùng timestamp, timestamp có thể không phản ánh thứ tự commit, và có transaction commit trễ. Các phương án thay thế: composite cursor, source commit sequence, CDC offset, overlap window kết hợp dedup, stable source snapshot.
- **Có nên retry không**: lỗi tạm thời thì retry. Lỗi xác định thì không, ví dụ cột nguồn đã bị xóa thì retry hàng chục lần cũng vô ích.
- **Recompute hay delta**: không có cách tối ưu cho mọi trường hợp.
  - Aggregate nhỏ: tính lại cả partition đơn giản và đáng tin hơn.
  - Dữ liệu cực lớn: cập nhật theo delta hiệu quả hơn nhưng phải kiểm soát version và consistency chặt.
  - Ngoài ra có thể merge theo business key, hoặc reprocess các materialized aggregates.
- **Gold lỗi nhưng Silver đã thành công**: không cần chạy lại ingestion. Xử lý lại Gold từ Silver đã commit.
- **RPO/RTO và freshness SLO là hai thứ khác nhau**: hạ tầng có thể khôi phục trong RTO, nhưng dữ liệu phân tích vẫn cần thêm thời gian backfill mới đầy đủ.

**6. Best practices / nguyên tắc thiết kế** (10 Production Design Principles)
1. **Assume Failure**: network, compute, DB, broker và storage đều có thể lỗi; pipeline phải phát hiện và xử lý được.
2. **Make Writes Idempotent**: đánh giá khả năng retry của mọi thao tác `INSERT`, `UPDATE`, `MERGE`, `AGGREGATE`, `APPEND`, `PARTITION OVERWRITE`. Dùng `MERGE`/`UPSERT` không có nghĩa đã hết duplicate.
3. **Separate Processing from Commit**: nếu không có một transaction bao trùm toàn bộ, phải dùng idempotent retry, reconciliation hoặc transactional coordination.
4. **Preserve Replayable Inputs**: giữ input đủ lâu cho recovery, audit và reprocessing; raw immutable events là lựa chọn tốt khi kiến trúc và chính sách lưu trữ cho phép.
5. **Track Processing State**: phải trả lời được đã xử lý đến đâu, đang xử lý gì, run nào thành công hay lỗi, dùng logic version nào, output nào đã commit.
6. **Design for Late Data**: có chính sách rõ cho dữ liệu đến trễ, historical corrections và out-of-order events.
7. **Make Backfill a First-Class Capability**: không dựa vào script SQL viết tay. Backfill cần scope management, execution tracking, concurrency control, validation, approval khi cần và audit trail.
8. **Protect Concurrent Writes**: dùng transaction isolation, locking hoặc optimistic concurrency để tránh conflict và lost update.
9. **Validate Recovery Results**: job thành công chưa chắc dữ liệu đúng; phải reconcile theo business keys và control totals.
10. **Design Recovery Before Production**: xác định yêu cầu recovery cùng lúc với kiến trúc. Production-ready nghĩa là khôi phục có kiểm soát được cả trong điều kiện bất thường.

Nguyên tắc bổ sung:
- Dedup theo event identity; áp dụng state theo business key kết hợp source version.
- Reprocessing phải được version hóa, ghi lại dataset, period, `logic_version`, `source_snapshot`, `execution_id` và `reason`. Để tái tạo được kết quả, cần kiểm soát code version, input snapshot, configuration, dependencies và reference data.
- Khi tái tạo partition:
  - Không cho người dùng đọc dữ liệu đang ghi dở.
  - Không xóa partition cũ trước khi kết quả mới sẵn sàng, trừ khi có transactional protection.
  - Kiểm soát downstream và ghi rõ logic version.
  - Không để nhiều job ghi cùng một partition.
  - Table format có transactional writes giúp việc thay thế an toàn hơn.
- Xác định rõ dùng event time, transaction time, processing time hay business effective date.
- Xác định thứ tự event bằng source sequence/version đáng tin cậy, dựa trên semantics và metadata của nguồn.
- Reconciliation có thể dùng record count, unique key count, control/amount totals, checksum, so sánh source-to-target, so sánh version. Luôn đối chiếu với nguồn kiểm soát có cùng định nghĩa và phạm vi.
- Muốn reprocess kỳ tài chính đã chốt thì cần phê duyệt nghiệp vụ và kiểm soát thay đổi số liệu báo cáo.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Dùng `Read → Transform → Write → Success` mà không có state, commit protocol hay recovery.
- Cộng dồn delta kiểu `SET total = total + 10,000,000`, nên mỗi lần retry lại cộng thêm.
- Tin `MERGE`/`UPSERT` tự idempotent mà không kiểm tra:
  - Business key có duy nhất không.
  - Input có duplicate không, có nhiều version của cùng record không.
  - Update cũ có thể đến muộn hơn update mới không.
  - Có nhiều writer cùng lúc không.
  - Việc ghi dữ liệu và checkpoint có nhất quán với nhau không.
- Chỉ dedup theo `trade_id`, làm mất những lần cập nhật hợp lệ của cùng giao dịch.
- Dùng `updated_at` làm cursor mà không lường trước timestamp trùng hoặc commit trễ, dẫn đến bỏ sót dữ liệu.
- Nhầm event-time watermark với source cursor/offset.
- Cập nhật checkpoint trước khi commit, dẫn đến mất dữ liệu.
- Nghĩ rằng Airflow có retry là pipeline đã an toàn, hoặc task "xanh" nghĩa là kết quả nghiệp vụ đúng.
- Retry mọi loại lỗi, hoặc để nhiều pipeline retry dồn dập khi nguồn đang sự cố.
- Task xóa dữ liệu tạm khiến các bước sau không retry được.
- Dựa vào retention ngắn của Kafka để replay dữ liệu nhiều tháng.
- Xóa partition cũ trước khi có kết quả mới; cho người dùng đọc dữ liệu ghi dở; để nhiều job ghi chồng lên nhau.
- Chạy lại lịch sử bằng logic mới mà không versioning, khiến số liệu lệch với số đã công bố; chỉ lưu thời điểm chạy mà không lưu logic và input.
- Aggregate theo processing time, khiến giao dịch đến trễ rơi vào sai window.
- Update theo thứ tự nhận event.
- Gold chỉ xử lý partition của ngày hiện tại, bỏ sót correction cho ngày cũ.
- Giả định có global ordering trên nhiều stream.
- Không reconcile sau recovery. Ngược lại, cũng không nên mặc định hai hệ thống phải có cùng số bản ghi khi filter hoặc grain khác nhau.
- Đồng nhất RPO/RTO với freshness SLO.
- Backfill bằng script thủ công; tự động ghi đè số liệu regulatory/financial reporting đã công bố.
- Thành công 99% thời gian vẫn có thể gây sai dữ liệu nghiêm trọng nếu 1% lỗi còn lại không được xử lý đúng.

**8. Ví dụ minh họa**
- **Quy mô**: 10 triệu giao dịch mỗi ngày.
- **Giao dịch chuyển `PENDING` → `MATCHED`**: ingestion đưa event vào Bronze; processing cập nhật Silver rồi điều chỉnh Gold. Các chỉ số có thể phải tính lại: khối lượng theo mã chứng khoán, giá trị giao dịch theo khách hàng, doanh thu môi giới, số khách hàng giao dịch trong ngày.
- **Non-idempotent**: tổng giao dịch của khách C001 là 50,000,000. Chạy lần đầu cộng 10 triệu thành 60,000,000; retry cộng tiếp thành 70,000,000, tức là sai.
- **Idempotent**: `MERGE` vào `customer_daily_summary`.
  - Nguồn: `SUM(trade_amount)` từ `silver.trades` với `trade_date = 2026-10-20` và trạng thái `MATCHED`, nhóm theo customer và ngày.
  - Khớp theo `customer_id + trade_date`: có rồi thì gán lại giá trị, chưa có thì insert.
  - Cú pháp chỉ mang tính minh họa, phụ thuộc engine và table format.
- **Dedup theo event**: event E1001 (T5001, UPDATE, MATCHED) đến nhiều lần chỉ được áp dụng một lần.
- **Run 2 lỗi**: các run chạy theo giờ (00–01, 01–02, 02–03). Khi Run 2 lỗi, cần biết run đã xử lý những gì, đã commit chưa, có resume được không hay phải chạy lại cả cửa sổ.
- **Watermark**: pipeline `trading_incremental` có `last_committed_watermark = 2026-10-20T10:00:00`, cửa sổ chạy 10:00 → 10:05.
- **Checkpoint streaming**: Kafka partition 0 ở offset 15000, partition 1 ở offset 22000; aggregation state C001 = 150,000,000, C002 = 250,000,000.
- **Event time đến sai thứ tự**: 10:00 → 10:01 → 10:02 → 09:59 → 10:03.
- **Backfill**: trong các ngày 2026-10-01 → 05, ngày 03 và 04 bị Missing nên cần backfill. Nếu partition ngày 03 của `gold.fact_trade` sai thì tái tạo lại từ Silver.
- **Versioning metric**
  - Trading Revenue v1 = Brokerage Fee; v2 = Brokerage Fee − Eligible Adjustments.
  - Metadata của lần backfill: `gold.trading_revenue`, kỳ 2026-09-01 → 09-30, `logic_version 2.0.0`, `snapshot-2026-10-20`, `backfill-20261021-001`, lý do "Revenue logic correction".
- **Độ trễ thời gian**: Trade Executed 10:00:00 → CDC Captured 10:00:03 → Kafka Received 10:00:04 → Pipeline Reads 10:00:05 → Lakehouse Write 10:00:07. Trường hợp đến trễ, pipeline đọc lúc 10:15:00; nếu nhóm theo processing time thì giao dịch rơi vào sai window.
- **Out-of-order**
  - Các event PENDING(1), MATCHED(2), CANCELLED(3) đến theo thứ tự 1 → 3 → 2. Nếu update theo thứ tự nhận, trạng thái cuối sai thành MATCHED.
  - Quy tắc đúng: T001 đang ở version 3 thì event version 2 đến sau không được ghi đè.
- **Historical correction**: giao dịch ngày 2026-10-19 có correction ngày 2026-10-20, nên phải tính lại partition ngày 19. Correction này có thể ảnh hưởng Trading Value của ngày, doanh thu tháng và chỉ số Active Customer 30 ngày.
- **Reconciliation SQL**: theo từng `trade_date`, đếm số giao dịch và tính `SUM(trade_amount)` trên `silver.trades` với trạng thái MATCHED, rồi đối chiếu với nguồn kiểm soát.
- **RPO/RTO mẫu**: `trading_analytics` có RPO 5 phút, RTO 30 phút, chạy near_real_time, bật checkpointing và replay, bắt buộc idempotent sink. Tác giả nhấn mạnh đây chỉ là ví dụ, không phải SLA mặc định của ngành.
- **Case study**
  - Luồng: `Oracle Trading Core → CDC Connector → Kafka → Bronze → Silver Trade Events → Silver Trade State → Gold Trading Metrics → Trading Dashboard`.
  - Vòng đời giao dịch (minh họa): `CREATED → PENDING → MATCHED → (CORRECTED | CANCELLED)`.
  - *S1 – Duplicate event*:
    - Event {E1001, T001, version 3, MATCHED, 10,000,000} đã ghi xong nhưng consumer restart trước khi checkpoint, nên đọc lại event này. Nếu insert không kiểm soát sẽ sinh duplicate.
    - Cách làm đúng: giữ event identity, dedup trong phạm vi được đảm bảo, áp state theo business key + version, ghi sink theo kiểu transactional/idempotent, và chỉ đánh dấu progress khi kết quả đã an toàn.
  - *S2 – Sai thứ tự*:
    - Version 4 (CORRECTED) đến trước version 3 (MATCHED); version 3 không được ghi đè.
    - Nếu dữ liệu nằm trên nhiều stream không có thứ tự tổng thể, phải thiết kế lại phạm vi ordering guarantee thay vì giả định global ordering.
  - *S3 – Bronze/Silver SUCCESS, Gold FAILED*:
    - Xử lý lại Gold từ Silver đã commit.
    - Điều kiện: Silver hợp lệ, xác định được snapshot/change set, Gold ghi idempotent, không có writer xung đột, và reconcile sau đó.
    - Nếu dùng incremental aggregation thì phải đảm bảo không cộng lặp.
  - *S4 – Correction cho T001 (19/10, nhận ngày 20/10)*:
    - Thay đổi đi theo Bronze → Silver (theo version) → Gold.
    - Gold điều chỉnh Trading Value 19/10, Customer Trading Activity 19/10 và Monthly Trading Revenue tháng 10.
  - *S5 – Backfill 30 ngày do đổi cách tính Trading Revenue*:
    - Chạy theo quy trình 8 bước ở mục 4, dùng isolated output rồi atomic switch để production không bị thay đổi dở dang.
    - Kỳ tài chính đã chốt cần phê duyệt nghiệp vụ trước khi ghi đè.
- [Ghi chú] Bài không dùng các bảng ORDERS/CASH_BALANCE/POSITION/MARGIN. Ví dụ xoay quanh giao dịch: `trading_transactions`, `silver.trades`, `gold.fact_trade`, `gold.trading_revenue`.

**9. Công nghệ/công cụ được nhắc tới**
- **Apache Kafka**: kênh truyền CDC event; offset đóng vai trò source position. Retention có hạn nên không thể là nguồn replay dài hạn.
- **CDC Connector**: bắt thay đổi từ **Oracle Trading Core** (hệ thống nguồn giao dịch).
- **Apache Flink**: checkpoint, state, fault tolerance; exactly-once end-to-end cần source replay được và sink transactional/idempotent.
- **Airflow/orchestrator**: điều phối DAG, retry task, backfill. Bản thân retry của orchestrator chưa đủ đảm bảo an toàn.
- **Delta Lake/table formats**: `MERGE`, transactional writes, thay thế partition an toàn hơn.
- **Lakehouse Bronze/Silver/Gold**: Bronze giữ dữ liệu có thể replay; Silver giữ trạng thái chuẩn; Gold chứa metrics.
- **Các thành phần hỗ trợ**: SQL `MERGE`/`UPSERT`, state backend, Checkpoint/Offset Store, registry `pipeline_runs`, circuit breaker, rate limiter.
- **Tài liệu tham khảo**: Kafka Message Delivery Semantics; Flink Fault Tolerance & Guarantees; Airflow Backfill; Delta Lake Table Updates and MERGE; Delta Lake Documentation.

**10. Checklist / câu hỏi thiết kế**
- **`MERGE` có thật sự idempotent không?** Kiểm tra: key có duy nhất, input có duplicate, có nhiều version, update cũ có thể đến muộn, có nhiều writer, việc ghi và checkpoint có nhất quán.
- **Khi một run lỗi**: run đã xử lý gì, đã commit chưa, có resume được không, hay phải chạy lại cả cửa sổ?
- **Execution contract của task**: input, output kiểm tra được, quy tắc commit, retry policy, recovery strategy, chống ghi xung đột.
- **Retry policy**: backoff, max attempts, timeout, jitter, rate limit, circuit breaker, phân loại lỗi.
- **Điều kiện đánh dấu `SUCCEEDED`**: đã commit, đọc được, checks đã xong, progress nhất quán.
- **Điều kiện xử lý lại Gold từ Silver**: Silver hợp lệ, xác định được snapshot/change set, Gold idempotent, không có writer xung đột, có reconcile.
- **Backfill**: theo quy trình 8 bước ở mục 4.
- **Nguyên tắc chung**: 10 Production Principles ở mục 6.
- **Mỗi dataset cần chốt**: RPO, RTO, processing mode, checkpointing, replay, idempotent sink, và tách riêng freshness SLO.

**11. Kết luận & key takeaways**
- Incremental processing giúp platform hiệu quả hơn nhưng kéo theo các thách thức: quản lý state, xác định phần dữ liệu thay đổi, kiểm soát duplicate, xử lý event sai thứ tự, ghi kết quả nhất quán, khôi phục sau lỗi và tái xử lý lịch sử.
- Idempotency, Checkpointing, Retry, Replay, Backfill và Recovery là thành phần thiết kế cốt lõi, không phải chức năng phụ của orchestration framework.
- Công thức thực dụng: At-Least-Once + Idempotent Processing + Transactional Sink, và chỉ xác nhận progress sau khi commit.
- Bronze giữ raw immutable events để replay; backfill phải được version hóa (logic, snapshot, execution ID) và audit.
- Late data và correction lịch sử buộc pipeline phải hiểu dependency và business semantics, không chỉ dựa vào ingestion timestamp.
- Job thành công chưa có nghĩa dữ liệu đúng: luôn reconcile, và tách RPO/RTO khỏi freshness SLO.
- Trích dẫn: *"Idempotency không có nghĩa pipeline không chạy lại. Nó có nghĩa pipeline có thể chạy lại mà không làm sai trạng thái dữ liệu."*
- Trích dẫn (về pipeline đáng tin cậy): *"…pipeline có thể thất bại, chạy lại và phục hồi mà không làm sai kết quả dữ liệu."*

**12. Liên kết với các bài khác**
- **Bài 11**: phần cuối Bài 11 dẫn sang bài này với các câu hỏi về lỗi giữa chừng, gửi lặp, CDC replay và backfill.
- **Bài 5** (Orchestration): retry của orchestrator là chưa đủ, cần thêm execution contract.
- **Bài 6** (Data Quality): DQ phát hiện dữ liệu sai là một lý do để backfill; Data Failure được xử lý bằng quarantine.
- **Bài 8** (CDC): CDC event, offset, replay và vấn đề sai thứ tự.
- Phần mở đầu nhắc lại các bài trước về Ingestion, Lakehouse/Medallion, Data Contracts và Analytical Data Modeling, nhưng không ghi số bài.
- **Bài 13** (Data Observability – Từ Pipeline Monitoring đến khả năng "nhìn thấy" toàn bộ Data Platform): được giới thiệu ở cuối, với câu hỏi làm sao biết dữ liệu đang khỏe, phát hiện bất thường và hiểu tác động của sự cố trước khi business users nhận ra.
- [Ghi chú] Bài không dẫn chiếu Bài 10/11 trong phần thân, nhưng ví dụ versioning metric Trading Revenue và bước "Record Audit & Lineage" khớp với chủ đề metrics governance và lineage của hai bài đó.

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **Thiết kế ngay từ đầu, không vá sau.** Bài 11 có Governance by Design và đưa governance checks vào CI/CD. Bài 12 có Design Recovery Before Production và coi Backfill là năng lực hạng nhất. Cả hai coi đây là năng lực kiến trúc, không phải add-on của một công cụ như Catalog hay Airflow.
- **Chạy được về kỹ thuật chưa có nghĩa là đúng và đáng tin.**
  - Pipeline chạy thông suốt nhưng ownership coverage chỉ 20% (Bài 11).
  - Job `SUCCEEDED` vẫn cần reconcile (Bài 12).
  - Tương tự: gắn nhãn chưa phải là enforcement, có `MERGE` chưa phải là idempotent, orchestrator retry được chưa phải là an toàn, có lineage chưa phải là đã đánh giá rủi ro.
- **Metadata và khả năng truy vết là nền móng.** Bài 11 có 4 nhóm metadata, lineage và ownership registry. Bài 12 có run registry, logic version, source snapshot, execution ID và audit/lineage cho backfill. Mục đích chung là giải thích, tái tạo và truy vết được kết quả.
- **Semantics nghiệp vụ dẫn dắt thiết kế kỹ thuật, không giả định ngầm.**
  - Bài 11: định nghĩa do business owner phê duyệt; khóa khách hàng giữa các hệ thống không mặc định là 1-1.
  - Bài 12: phân biệt business key, event ID và version; phân biệt event time và processing time; không giả định global ordering hay coi timestamp là luôn an toàn.
- **Tự động hóa phần xác định được, để con người xử lý ngoại lệ và quyết định nghiệp vụ.** Bài 11 kết hợp metadata/lineage tự động với đăng ký thủ công và xác nhận của con người. Bài 12 yêu cầu duyệt scope backfill, và số liệu tài chính/regulatory phải được phê duyệt trước khi ghi đè.
- **Ưu tiên theo mức độ quan trọng và tiến hóa dần trên cùng một kịch bản.** Bài 11 đo KPI theo criticality và triển khai theo lộ trình 5 giai đoạn. Bài 12 đặt RPO/RTO/SLO theo từng dataset và chọn recompute hay delta theo quy mô dữ liệu. Cả hai dùng chung kịch bản công ty chứng khoán (Oracle Trading Core, giao dịch MATCHED, margin exposure) trên nền Bronze/Silver/Gold.


---

## Bài 13: Data Observability - Từ Pipeline Monitoring đến khả năng “nhìn thấy” toàn bộ Data Platform
*(Series Modern Data Platform, đăng 13/10/2026. Subtitle: “Thiết kế kiến trúc giám sát Data Platform từ Pipeline, Dataset, Data Product đến Reliability, Performance, Cost và Operational Intelligence.”)*

Mục lục (H2): 1. Data Observability là gì? Vì sao Pipeline Monitoring không còn đủ? | 2. Data Observability Architecture – Thiết kế hệ thống quan sát nhiều lớp | 3. Năm trụ cột của Data Observability – Quan sát sức khỏe dữ liệu | 4. Pipeline Observability – Quan sát toàn bộ vòng đời xử lý dữ liệu | 5. Data Lineage & Impact Analysis – Từ phát hiện lỗi đến hiểu tác động | 6. Data SLO & Reliability Engineering – Định nghĩa thế nào là dữ liệu đáng tin cậy | 7. Anomaly Detection & Intelligent Alerting – Giảm nhiễu cảnh báo | 8. Performance & Cost Observability – Quan sát hiệu năng và chi phí toàn nền tảng | 9. Operational Intelligence – Từ Observability đến vận hành chủ động | 10. Reference Architecture & Implementation Roadmap – Triển khai Data Observability như thế nào? | Kết luận – Data Observability là nền tảng của Data Platform Reliability

**1. Bối cảnh & vấn đề mở đầu**
Các bài trước đã xây xong Ingestion, Storage, Medallion, Orchestration, Data Quality, Analytical Modeling, Semantic Layer và Data Product. Khi ghép lại, platform trở nên rất phức tạp. Tác giả giả định quy mô 20+ source systems, 200+ Data Products, 2.000+ datasets, 500+ pipelines, hơn 10.000 tasks/ngày, xử lý hàng triệu đến hàng tỷ records. Dữ liệu đi qua chuỗi `Oracle/PostgreSQL/SQL Server → CDC/Batch/API → Kafka/Airflow → Data Lakehouse → Spark/dbt → Data Warehouse → Semantic Layer → BI/AI/API`.

Lúc này, hỏi “pipeline có chạy thành công không?” là chưa đủ. Cần trả lời được:
- Dữ liệu có đến đúng giờ không?
- Pipeline SUCCESS nhưng dữ liệu có thực sự được cập nhật không?
- Vì sao thời gian xử lý tăng từ 10 lên 45 phút?
- Một dataset lỗi ảnh hưởng tới những báo cáo và Data Product nào?
- Vì sao chi phí tăng 40% trong khi khối lượng dữ liệu không tăng tương ứng?
- Làm sao tìm nhanh root cause?

**2. Luận điểm cốt lõi**
Hạ tầng và pipeline “xanh” không chứng minh được dữ liệu đáng tin cậy. Data Observability là một năng lực dùng chung, phủ toàn platform, chứ không phải một dashboard hay công cụ monitoring riêng lẻ. Nó liên kết telemetry, metadata, data health, lineage, SLO, cost và incident để trả lời: vì sao có lỗi, lỗi ảnh hưởng đến đâu, và khôi phục thế nào. Độ tin cậy (reliability) được đo ở cấp Data Product, không phải ở cấp pipeline.

**3. Khái niệm chính**
- **Monitoring và Observability:**
  - Monitoring theo dõi những điều kiện đã định nghĩa sẵn.
  - Observability giúp hiểu trạng thái, nguyên nhân và tác động, kể cả những tình huống chưa lường trước.
  - Monitoring là *một phần* của Observability, hai thứ không loại trừ nhau.
- **Các tầng sức khỏe:** `Infrastructure Health ≠ Pipeline Health ≠ Data Health ≠ Business Reliability`.
- **Data Observability (DO) và Data Quality (DQ):** DO không thay thế DQ.
  - DO *sử dụng* kết quả DQ checks, metadata, lineage và telemetry.
  - DQ xác định và thực thi các yêu cầu chất lượng.
  - DO quan sát trạng thái, phát hiện bất thường, xác định tác động và hỗ trợ điều tra sự cố trên toàn platform.
- **Telemetry:** OpenTelemetry chuẩn hóa việc thu thập và xuất traces, metrics, logs. Dataset metadata, profiling và lineage cần thêm cơ chế khác.
- **Năm trụ cột:** Freshness, Volume, Distribution, Schema, Lineage. Đây là mô hình phổ biến, nhưng mỗi nền tảng có thể nhóm khác nhau.
- **Bốn mốc thời gian khi đo freshness:** source event time, ingestion time, processing time, publication time. Pipeline vừa chạy xong không có nghĩa là dữ liệu đã mới.
- **Baseline theo ngữ cảnh:** kỳ vọng được tính theo pipeline, lịch chạy, ngày trong tuần, khối lượng dữ liệu, chế độ xử lý, lịch giao dịch và mùa vụ, thay cho một ngưỡng cố định.
- **Distributed Execution Tracing:** tách thời gian của một logical pipeline theo từng bước, dựa trên execution context hoặc correlation ID dùng chung.
- **Ba loại lineage:**
  - Technical Lineage: dataset được tạo ra từ đâu và biến đổi thế nào.
  - Operational Lineage: phụ thuộc gắn với từng lần chạy cụ thể (job, run, inputs, outputs, status).
  - Business Lineage: nối technical asset với metric, dashboard và quyết định kinh doanh.
- **Blast Radius:** phạm vi ảnh hưởng của một sự cố.
- **SLI / SLO / SLA:** xem bảng ở mục 5. **Error Budget:** số kỳ cập nhật “xấu” được phép trong một kỳ đo.
- **Correlation & Deduplication:** gom các tín hiệu thành một incident. Correlation không tự động chứng minh quan hệ nhân quả.
- **Unit Economics:** chi phí tính trên một đơn vị workload.
- **Operational Intelligence:** giúp trả lời *What happened? Why did it happen? What should we do next?*
- **Automated Remediation**, **AI-assisted Operations**.
- **Cardinality:** các định danh như `run_id` có cardinality cao, cần thiết kế cẩn thận để không làm tăng tải và chi phí của metrics backend.

**4. Kiến trúc, pattern & quy trình**
- **Logical Architecture (Hình 2 và 3, hai ảnh trùng nhau):**
  - Tầng nguồn tín hiệu: Source & CDC, Orchestration, Processing, Storage, Serving, Infrastructure.
  - Telemetry & Metadata Collection: Metrics, Logs, Traces, Events, Data Profiles, Lineage.
  - Data Observability & Operational Intelligence: Health Monitoring, Lineage & Impact, Anomaly Detection, SLO & Alerts, Incident Management, Cost & Performance.
  - Tầng trên cùng (trao đổi hai chiều): Data Consumers & Business Services (BI, AI, API, Semantic Layer, Data Products).
  - Chú thích của tác giả: DO là lớp quan sát xuyên suốt, không phải công cụ monitoring độc lập.
- **Bốn phần của kiến trúc:**
  - *Observed Systems:* source, ingestion, streaming, orchestration, processing, storage, DW, Data Products, BI/AI. Mỗi loại cho tín hiệu riêng:
    - Kafka: consumer lag, throughput.
    - Airflow: trạng thái và thời lượng DAG/task.
    - Spark: job duration, shuffle, executor metrics.
    - Database: query performance, locks, storage, throughput.
    - Dataset: freshness, volume, schema, thống kê dữ liệu.
  - *Telemetry Collection:* APIs, Exporters, Agents, SDK Instrumentation, Execution Events, Metadata Collectors, Data Profiling Jobs, Lineage Events.
  - *Observability Processing:* chuẩn hóa telemetry → liên kết job với dataset → tính health → phát hiện bất thường → xác định dependency và impact → đánh giá Data SLO → tạo incident và gửi cảnh báo.
  - *Observability Consumption* (Hình 4). DO phải phục vụ cả góc nhìn kỹ thuật lẫn nghiệp vụ:

| Nhóm | Nhu cầu |
|---|---|
| Data Engineer | Debug và tối ưu pipeline |
| Data Platform Engineer | Theo dõi reliability, performance |
| Data Architect | Hiểu dependency và bottleneck |
| Data Product Owner | Theo dõi SLO của sản phẩm dữ liệu |
| Business Owner | Biết dữ liệu có đủ tin cậy để dùng không |
| FinOps | Phân tích chi phí xử lý và lưu trữ |

- **Blast Radius gom thành một incident:**
  - Chuỗi lan truyền: `Source Schema Change → CDC Failure → Bronze Stale → Silver Stale → Gold Data Products → BI/AI/API`.
  - Thay vì 5 cảnh báo rời: *Root Incident* là Oracle Source Schema Change; *Downstream Symptoms* gồm CDC Ingestion Failed, Bronze/Silver Stale, Gold Data Product Delayed.
  - Đây là bước chuyển từ cảnh báo theo từng component sang incident theo nguyên nhân và tác động.
- **Incident Lifecycle (Hình 10):** `Detect → Correlate → Assess Impact → Investigate → Remediate → Verify & Learn`.
  - Phát hiện tín hiệu bất thường.
  - Nhóm các tín hiệu liên quan.
  - Xác định Data Product và consumer bị ảnh hưởng.
  - Phân tích nguyên nhân gốc.
  - Khôi phục bằng retry, replay hoặc backfill.
  - Kiểm tra dữ liệu, đóng incident và cải tiến.
- **AI-assisted Ops:** `Observability Data → AI Assistant → Investigation Plan → Human Approval / Policy → Remediation Execution`.
- **Kiến trúc triển khai thực tế (10.2), gồm hai nhánh:**
  - Nhánh telemetry của platform: `Airflow/Kafka/Spark → Telemetry/Events → Metrics→Prometheus | Logs→Elasticsearch | Traces→Tempo → Grafana UI`.
  - Nhánh data observability: `Data Profiles + Lineage Events + Metadata Events → Metadata/Lineage Platform → Health & SLO Evaluation → Correlation & Alerting → Incident/Impact View`.
  - Không cần gom tất cả vào một database:

| Loại dữ liệu | Nơi lưu |
|---|---|
| Time-series metrics | Prometheus |
| Application logs | Elasticsearch |
| Distributed traces | Tempo |
| Lineage metadata | Metadata Platform |
| Dataset health | Observability Repository |
| SLO / Incident data | Operational Repository |

  Một lớp UI hoặc API tổng hợp thông tin từ các hệ thống này.
- **Chuẩn hóa Observability Metadata (10.3):**
  - Dùng bộ định danh chung: platform, environment, domain, data_product, pipeline (id, engine, run_id), dataset (id, layer), ownership (team, criticality).
  - Gắn vào metadata, events hoặc telemetry attributes ở những chỗ phù hợp; không bắt buộc metric nào cũng mang đủ.
  - Data Product ID, Dataset ID, Pipeline ID và Run ID phải liên kết được với nhau.

**5. Framework ra quyết định & so sánh**

Monitoring và Observability (Hình 1):

| Tiêu chí | Monitoring | Observability |
|---|---|---|
| Mục tiêu | Phát hiện trạng thái bất thường | Hiểu trạng thái, nguyên nhân, tác động |
| Câu hỏi | Có lỗi không? | Vì sao lỗi, ảnh hưởng đến đâu? |
| Phạm vi | Metrics, logs, trạng thái hệ thống | + traces, metadata, lineage, data health |
| Cách tiếp cận | Theo dõi điều kiện đã định nghĩa | Phân tích cả tình huống chưa dự đoán |
| Ví dụ | Airflow task failed | Task failed do upstream schema change, ảnh hưởng 3 Data Products |

Góc quan sát Batch và Streaming (Hình 7):

| Batch | Streaming |
|---|---|
| Scheduled Start | Continuous Execution |
| Job Duration | Processing Latency |
| Completion Status | Consumer Lag |
| Records per Batch | Events per Second |
| Retry / Backfill | Reprocessing / Replay |
| Schedule Delay | Event-time Lag |

SLI, SLO, SLA (Hình 8):

| Khái niệm | Vai trò |
|---|---|
| SLI – Service Level Indicator | Chỉ số đo lường |
| SLO – Service Level Objective | Mục tiêu độ tin cậy |
| SLA – Service Level Agreement | Cam kết dịch vụ, có thể kèm hậu quả khi vi phạm |

Các cách phát hiện và cảnh báo (mục 7):

| Cách | Mô tả | Lưu ý |
|---|---|---|
| Rule-based | IF consumer lag > ngưỡng / freshness > 30 phút / pipeline failed THEN alert | Rõ ràng, dễ triển khai; khó thích ứng khi workload biến động |
| Baseline-based | So với khoảng kỳ vọng tính từ lịch sử | Phải tính lịch giao dịch, ngày nghỉ, mùa vụ, đặc điểm dữ liệu |
| Correlation & Dedup | Liên kết qua Pipeline ID, Run ID, Dataset ID, Data Product ID, Upstream Dependency, Event Timestamp | Correlation không phải causation; tách nguyên nhân đã xác nhận với nguyên nhân đang nghi ngờ |
| Alert theo Business Impact | `Severity = Technical Impact + Business Criticality + SLO Risk + Dependency Impact` | Là cách kết hợp để phân loại, không nhất thiết là phép cộng điểm đơn giản |

- **Thước đo reliability:** không phải `All Pipelines Successful` mà là `Data Product Meets SLO`. Pipeline health chỉ là yếu tố đóng góp, không phải kết quả cuối.
- **Error Budget hỗ trợ các quyết định:**
  - Có nên ưu tiên sửa reliability thay vì làm tính năng mới?
  - Một thay đổi pipeline có đang làm tăng tỷ lệ vi phạm SLO?
  - Có cần rollback phiên bản transformation?
  - Có nên tăng dự phòng cho ingestion?
- **Reliability, Performance và Cost là một bài toán chung:**
  - Cắt compute quá mạnh → xử lý lâu hơn → vi phạm Freshness SLO.
  - Tăng tài nguyên không kiểm soát → chi phí tăng mà hiệu quả cải thiện không đáng kể.
  - Vì vậy phải tối ưu ba yếu tố cùng lúc.
- **Build hay buy:** không bắt buộc mua một nền tảng chuyên dụng. Có thể tận dụng công nghệ sẵn có rồi bổ sung phần còn thiếu.

**6. Best practices / nguyên tắc thiết kế**
- Xem DO là năng lực dùng chung của platform, phục vụ cả kỹ thuật và nghiệp vụ.
- **Đo freshness:** tách đúng bốn loại thời gian. Tính lịch hoạt động của nguồn: dataset giao dịch không nên bị coi là stale vào ngày nghỉ.
- **Trước khi kết luận lỗi về volume hay distribution:** so với lịch sử, ngày trong tuần, lịch giao dịch và các yếu tố nghiệp vụ. DO chỉ phát hiện tín hiệu; xác định nguyên nhân cần kết hợp kiểm tra nghiệp vụ và DQ.
- Pipeline phải phát ra đủ các execution metrics (xem mục 10) và có baseline theo ngữ cảnh.
- **Tracing:** các thành phần phải chia sẻ execution context hoặc correlation ID. OpenTelemetry hỗ trợ distributed tracing, nhưng nối một execution đi qua Kafka, Airflow, Spark và batch thường cần thêm instrumentation.
- **Streaming:** theo dõi consumer lag cùng với event-time freshness, throughput và trạng thái xử lý thực tế.
- Con số impact phải được tính từ metadata và dependency thực tế, không suy đoán.
- **SLO:**
  - Thống nhất giữa Data Product Owner, Platform Team và người dùng dữ liệu.
  - Định nghĩa rõ mẫu số, lịch đo và tiêu chí thế nào là một kỳ cập nhật thành công.
  - Không áp máy móc SLO kiểu uptime cho mọi loại dataset.
- **Cost:**
  - Phân tích theo Environment, Project, Domain, Pipeline, Data Product, Compute Engine, Storage Layer.
  - Với tài nguyên dùng chung, phân bổ chi phí có thể chỉ là ước tính, nên cần quy tắc allocation rõ ràng.
  - Unit cost chỉ so sánh giữa các workload cùng loại.
- **Performance:** dựa vào bằng chứng (shuffle, spill, skew, partition, execution plan) thay vì tăng CPU/memory theo cảm tính.
- **Tự động hóa:** remediation phải có guardrails. AI chỉ phân tích và đề xuất; kết luận phải được xác minh bằng dữ liệu quan sát.
- Triển khai theo mức độ trưởng thành. Điều quan trọng là trả lời được các câu hỏi vận hành, không phải số lượng công cụ.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Thấy dashboard hạ tầng và DAG đều xanh thì coi như dữ liệu khỏe.
- Chỉ theo dõi SUCCESS/FAILED/RUNNING.
- Dùng ngưỡng cố định như `Alert if Duration > 10 minutes`, bỏ qua việc các lần chạy cuối tháng vốn lâu hơn.
- Coi mọi biến động lớn về volume hay distribution là lỗi.
- Coi consumer đang RUNNING nghĩa là theo kịp producer.
- Phân tích tác động thủ công khi đã có hàng trăm pipeline.
- **Alert storm:** 6 cảnh báo độc lập từ 09:00 đến 09:05 cho cùng một sự cố (DAG Failed → Bronze Stale → Silver Stale → Gold Stale → Dashboard Delayed → Freshness SLO Violated).
- Đánh đồng correlation với causation.
- Xử lý mọi dataset như nhau, bất kể mức độ quan trọng.
- Chỉ nhìn tổng hóa đơn cloud.
- So unit cost giữa CDC nhẹ và workload có complex joins/aggregations.
- **Rủi ro khi tự động khắc phục:**
  - Replay CDC events khi không có idempotency → duplicate records.
  - Backfill trong lúc downstream vẫn đang chạy → dữ liệu không nhất quán.
- Trao cho AI quyền tự động sửa mọi sự cố.
- Các ngộ nhận về công cụ:
  - Cho rằng phải mua nền tảng chuyên dụng.
  - Cho rằng OpenTelemetry tự tạo ra Data Lineage.
  - Cho rằng có Data Catalog là đã đủ Observability.
- Gắn các nhãn cardinality cao (như `run_id`) vào mọi metric.
- Cố triển khai mọi thành phần ngay từ đầu.

**8. Ví dụ minh họa** (bối cảnh công ty chứng khoán)
- **Dashboard “xanh” nhưng dữ liệu sai:** CPU 65%, Memory 72%, DAG SUCCESS, Spark COMPLETED, DB ONLINE, Kafka consumer RUNNING. Vậy mà người dùng báo báo cáo doanh thu hôm nay hiển thị dữ liệu hôm qua, và tổng giá trị giao dịch trên DW thấp hơn hệ thống nguồn.
- **Pipeline giao dịch:** `Oracle Trading DB → CDC → Kafka Topic → Bronze → Silver → Gold → Trading Dashboard`.
  - DAG `trading_daily_pipeline` báo SUCCESS sau 8 phút.
  - Thực tế: Source 1.200.000 records, Gold 1.080.000, thiếu 120.000.
  - Trạng thái đúng phải là: Execution SUCCESS · Freshness HEALTHY · Completeness DEGRADED · Business Impact HIGH.
- **Freshness:** `trading_transactions` kỳ vọng cập nhật mỗi 5 phút. Source event mới nhất lúc 10:00, dữ liệu publish mới nhất lúc 09:40 → lag 20 phút, vi phạm SLO 5 phút.
- **Volume:**
  - Thứ 2 đến Thứ 5: 1.200.000 / 1.180.000 / 1.250.000 / 1.210.000. Thứ 6 chỉ còn 320.000.
  - Có thể do Missing CDC Events, Failed Partition Load, Incorrect Filtering, Partial Source Extraction, hoặc kinh doanh thực sự giảm.
- **Distribution:**
  - Bình thường BUY 48–55%, SELL 45–52%; đột ngột thành BUY 95%, SELL 5% → cần điều tra.
  - Các chỉ số dùng: Null Rate, Distinct Count, Min/Max, Average, Std Dev, Percentiles, Value Distribution.
- **Schema:**
  - `amount DECIMAL(18,2)` đổi thành `VARCHAR(50)`, lan qua CDC Connector → Bronze → Silver → Gold Aggregation → Trading Dashboard.
  - Cần phát hiện: thêm/xóa cột, đổi kiểu dữ liệu, đổi nullability, schema drift, nguy cơ vi phạm Data Contract.
- **Lineage:** `Oracle.trading_orders → bronze.trading_orders → silver.valid_orders`, rồi tách thành `gold.daily_volume` (Trading Dashboard) và `gold.broker_performance` (Broker Dashboard). Khi `silver.valid_orders` stale, hệ thống phải chỉ ra 2 Gold datasets và các dashboard phụ thuộc.
- **Một lần chạy pipeline:**
  - `trading_silver_transform`, run `20261021_090000`, SUCCESS. Input 1.200.000, output 1.198.500, retry 2.
  - Chạy 18 phút so với bình thường 6 phút → chậm gấp 3, là tín hiệu cần theo dõi.
  - Baseline mẫu: ngày thường 5–8 phút, cuối tháng 20–35 phút.
- **Tracing:** Extract 2 phút, Kafka Wait 12, Bronze Write 1, Spark Transform 3, Gold Publish 1 → bottleneck nhiều khả năng nằm ở khâu chờ/tiêu thụ Kafka, không phải Spark.
- **Ba tầng lineage:**
  - Technical: `Oracle.CFMAST → Bronze.cf_customer → Silver.customer_profile → Gold.customer_360`.
  - Operational: job `build_customer_360`, run `run_20261021_080000`; inputs `silver.customer_profile` và `silver.customer_accounts`; output `gold.customer_360`; FAILED.
  - Business: `gold.daily_trading_volume → Trading Metrics → Executive Dashboard → Business Decision`; hiển thị 2 Data Products, 4 dashboards, 3 business teams bị ảnh hưởng.
- **SLO manifest (YAML minh họa)** cho `daily_trading_summary`, owner `trading_analytics`:
  - Freshness: publish trước 08:00 (Asia/Ho_Chi_Minh, chỉ tính ngày làm việc), target 99,5%.
  - Availability: 99,9%.
  - Completeness: `min_reconciliation_ratio` 0,999.
- **Error Budget:** Freshness SLO tháng là 99%, có 100 kỳ cập nhật hợp lệ → chỉ được phép 1 kỳ không đạt. Thực tế có 3 → VIOLATED.
- **Baseline anomaly:** kỳ vọng 900.000–1.300.000, quan sát 350.000 → Anomaly, severity HIGH.
- **Incident INC-1024:**
  - Root signal: Kafka Consumer Lag Increased.
  - Tín hiệu liên quan: Bronze Freshness Delayed, Silver Processing Delayed, Gold SLO At Risk.
  - Data Product bị ảnh hưởng: Real-time Trading Analytics.
- **Mức độ ưu tiên:** Dataset A (Internal Experiment, LOW) và Dataset B (Regulatory Reporting, CRITICAL) gặp cùng lỗi freshness nhưng cần xử lý khác nhau.
- **Performance:**
  - Spark từ 8 lên 32 phút trong khi dữ liệu chỉ tăng 5% → tăng trưởng không giải thích được việc chậm gấp 4.
  - Cần quan sát: CPU, Memory, Shuffle Read/Write, Spill to Disk, Partition Distribution, Task Skew, I/O Throughput, Query Execution Plan.
  - Nguyên nhân khả dĩ: data skew, partition không phù hợp, join strategy kém, thiếu tài nguyên hoặc contention, đọc lại dữ liệu quá nhiều, execution plan thay đổi.
- **Cost:** tháng 9 là $3.000, tháng 10 là $4.200 (+40%). Phân rã theo workload (Hình 9) → cần điều tra Risk Aggregation trước:

| Workload | Monthly Cost | Xu hướng |
|---|---|---|
| Trading Ingestion | $800 | Ổn định |
| Customer 360 | $1.200 | +15% |
| Risk Aggregation | $1.500 | +80% |
| Internal Reporting | $700 | −5% |

- **Unit economics:**
  - Chi phí cho 1 triệu records tăng từ $0,80 lên $1,45.
  - Các thước đo khác: cost per Data Product, per Pipeline Execution, per TB processed, per 1.000 queries.
- **RCA khi `daily_trading_summary` bị trễ:**
  - Tín hiệu: Gold Freshness SLO Violated; Silver Execution Delayed; Bronze Processing Lag tăng; Kafka Consumer Lag tăng; Source DB bình thường.
  - Nhận định: nguyên nhân nhiều khả năng nằm ở Kafka consumer hoặc khâu xử lý sau Kafka.
  - Incident summary: “Trading Data Delayed”; nghi ngờ Kafka Consumer Processing Lag; ảnh hưởng Bronze/Silver Trading Orders và Daily Trading Summary.
  - Đề xuất kiểm tra: consumer health, processing throughput, retry/error logs.
  - Tác giả nhấn mạnh đây chỉ là *hỗ trợ RCA*, chưa phải kết luận đã xác nhận.
- **AI assistant:**
  - Câu hỏi: “Vì sao trading pipeline sáng nay chậm hơn bình thường?”
  - Dữ liệu tổng hợp: bình thường 8 phút, hiện tại 26 phút; consumer lag tăng; input gần như không đổi; Spark ổn định.
  - Kết luận: bottleneck nhiều khả năng là Upstream Ingestion Delay.
- **Dashboard (Hình 12, số liệu minh họa):**
  - Tổng quan: 3 active incidents; Pipeline Success 98,7% (24h); Data Products SLO 96,2%; 24 stale datasets; Processing Cost $4.200/tháng.
  - Sức khỏe Data Product: Customer 360 đạt mọi SLO; Trading Analytics bị giảm freshness; Risk Reporting vi phạm SLO.
  - [Ghi chú] Hình này minh họa đúng luận điểm: tỷ lệ pipeline thành công cao vẫn có thể đi cùng Data Product vi phạm SLO.

**9. Công nghệ/công cụ được nhắc tới**
Reference Technology Stack (Hình 11). Tác giả lưu ý các công cụ chồng lấn chức năng, bảng chỉ để tham khảo, không bắt buộc triển khai cùng lúc:

| Capability | Công nghệ tham khảo |
|---|---|
| Infrastructure Metrics | Prometheus, Grafana |
| Logs | Elasticsearch, OpenSearch, Loki |
| Distributed Tracing | OpenTelemetry, Tempo, Jaeger |
| Workflow Monitoring | Apache Airflow |
| Streaming Monitoring | Kafka Exporters, Kafka Metrics |
| Data Quality Checks | Great Expectations, Soda, dbt Tests |
| Data Lineage | OpenLineage, Marquez |
| Metadata Catalog | OpenMetadata, DataHub |
| Alerting | Alertmanager, Grafana Alerting |
| Cost Monitoring | Cloud Billing, Custom Metrics |
| Incident Management | Alertmanager integrations, PagerDuty, Jira |

- **OpenTelemetry:** chuẩn hóa thu thập và xuất traces, metrics, logs; hỗ trợ distributed tracing cho ứng dụng. Nó *không* tự tạo Data Lineage.
- **OpenLineage:** mô hình Job, Run, Dataset cùng hệ thống facets.
- **Nguồn dữ liệu:** Oracle, PostgreSQL, SQL Server.
- **Kafka:** cung cấp consumer lag và throughput.
- **Airflow:** cung cấp trạng thái và thời lượng DAG/task.
- **Spark và dbt:** engine xử lý dữ liệu.
- **Monte Carlo:** nguồn tham khảo về các trụ cột của Data Observability.
- **AI Assistant:** lớp hỗ trợ phân tích, chỉ đề xuất.
- [Ghi chú] Hình 5 chỉ là logo trích dẫn của OpenLineage, không chứa bảng.

**10. Checklist / câu hỏi thiết kế**
- **Maturity model (Hình 13):**

| Level | Mục tiêu | Năng lực |
|---|---|---|
| 1 – Visibility | Biết chuyện gì đang xảy ra | Metrics, logs, pipeline status |
| 2 – Data Health | Biết dữ liệu có bất thường không | Freshness, volume, schema, profiling |
| 3 – Reliability | Đo được độ tin cậy | Data Product SLO, owner, alerting |
| 4 – Intelligence | Hiểu nguyên nhân và tác động | Lineage, correlation, RCA, cost |
| 5 – Proactive Operations | Chủ động ngăn ngừa, khắc phục | Anomaly detection, automation, AI assistance |

- **Roadmap ba giai đoạn:**
  1. Dùng hệ thống monitoring sẵn có cho Airflow, Kafka, Spark, database, storage; thêm freshness/volume monitoring cho các dataset quan trọng.
  2. Thiết lập ownership, SLO, metadata và lineage cho các Data Product ưu tiên cao.
  3. Nối telemetry, lineage, incident và cost thành Operational Intelligence. Chỉ khi đã đủ dữ liệu và quy trình kiểm soát mới mở rộng sang anomaly detection và automated remediation.
- **Execution metrics tối thiểu cho mỗi pipeline (Hình 6):**
  - Execution Duration (thời gian xử lý), Success Rate, Retry Count.
  - Queue Waiting Time (thời gian chờ tài nguyên).
  - Processing Throughput (record hoặc byte mỗi giây), Input/Output Records.
  - Processing Lag, Resource Consumption (CPU, memory, I/O).
- **Các chiều để xây baseline:** Pipeline, Schedule, Day of Week, Data Volume, Processing Mode.
- **Automated remediation:**
  - Các hành động có thể tự động: Retry Failed Task, Restart Failed Consumer, Replay Kafka Events, Backfill Missing Partition, Rebuild Affected Dataset.
  - Điều kiện bắt buộc đi kèm:
    - Điều kiện kích hoạt rõ ràng.
    - Idempotency và data consistency.
    - Giới hạn số lần retry.
    - Audit trail.
    - Rollback hoặc recovery plan.
    - Cơ chế phê duyệt cho hành động rủi ro cao.
- **Dashboard bốn cấp:**
  - Executive: Data Product Reliability, Critical Incidents, SLO Compliance, Overall Platform Cost.
  - Platform Operations: Pipeline Execution, Infrastructure Health, Ingestion Lag, Processing Performance, Capacity & Cost.
  - Data Product: Freshness, Completeness, Data SLO, Lineage, Affected Consumers.
  - Incident Investigation: Incident Timeline, Correlated Alerts, Related Logs/Traces, Upstream Dependencies, Root Cause Evidence, Recovery Status.
- **Bộ câu hỏi đích:** chuyển từ “Is the pipeline running?” sang “Is the data reliable? Why is it degraded? What is impacted? How can we recover?”

**11. Kết luận & key takeaways**
- Khi platform còn nhỏ, có thể vận hành bằng logs, dashboard và cảnh báo đơn giản. Ở quy mô hàng trăm Data Products và hàng nghìn datasets thì cách đó không còn đủ.
- Data Quality và Data Observability có vai trò khác nhau và bổ trợ nhau.
- Pipeline Success không đồng nghĩa với Data Product Reliability: dữ liệu vẫn có thể stale, thiếu hoặc sai kỳ vọng của consumer.
- Observability không chỉ là Monitoring Dashboard. Giá trị thật nằm ở việc nối dữ liệu kỹ thuật với Data Product, Business Impact, Reliability và Cost.
- Khi kết hợp Lineage, SLO, Performance Monitoring, Cost Analytics và Incident Management, Observability trở thành nền tảng cho Operational Intelligence. Tự động hóa và AI phải có guardrails và con người phê duyệt.
- Một platform trưởng thành phải chứng minh được dữ liệu đúng kỳ vọng, phát hiện khi không còn đúng, và khôi phục có kiểm soát.
- Hai trích dẫn tiêu biểu:
  - “A reliable Data Platform is not one that never fails, but one that can detect, understand, and recover from failures before they become business problems.”
  - “Từ alert theo từng component sang incident theo nguyên nhân và tác động.”

**12. Liên kết với các bài khác**
- **Các bài trước:** phần mở đầu tóm lại Ingestion, Storage, Medallion, Orchestration, Data Quality, Analytical Modeling, Semantic Layer và Data Product. Bài 13 là lớp quan sát phủ lên tất cả các thành phần đó.
- **Bài 6:** đã bàn chiến lược cho phép hay từ chối schema evolution. Bài 13 chỉ lo phần phát hiện thay đổi và đánh giá tác động.
- **Data Quality / Data Contract:** DO dùng kết quả DQ checks; schema drift được đánh giá theo nguy cơ vi phạm Data Contract.
- **Data Product:** “trách nhiệm của producer với consumer” được lượng hóa bằng SLI/SLO và Error Budget.
- **CDC/Kafka:** khi replay CDC events cần có idempotency.
- **Bài 14:** cuối bài giới thiệu chủ đề tiếp theo là Data Mesh.
- [Ghi chú] Bài 14 lại báo trước Bài 15 “Data Platform Operations – Từ Data Observability đến Performance, Cost & Operational Intelligence”, trùng chủ đề với mục 8–10 của Bài 13. Nhiều khả năng Bài 15 sẽ mở rộng phần vận hành này.

---

## Bài 14: Data Mesh - Khi Data Platform chuyển từ Centralized Data Warehouse sang Domain-oriented Data Products
*(Series Modern Data Platform, đăng 14/10/2026. Subtitle: “Vì sao Data Platform cần chuyển từ mô hình quản lý dữ liệu tập trung sang kiến trúc phân tán theo Business Domain, và làm thế nào để triển khai Data Mesh mà không tạo ra những Data Silo mới?”)*

Mục lục (H2): 1. Vấn đề của Centralized Data Platform | 2. Data Mesh là gì? | 3. Domain-oriented Data Ownership – Ai tạo ra dữ liệu, ai chịu trách nhiệm? | 4. Data as a Product – Khi Dataset trở thành sản phẩm | 5. Self-Serve Data Platform – Phân tán Ownership, không phân tán toàn bộ hạ tầng | 6. Federated Computational Governance – Quản trị phân tán nhưng không mất kiểm soát | 7. Data Mesh và các kiến trúc Data Platform hiện có | 8. Case Study – Xây dựng Data Mesh cho công ty chứng khoán | 9. Lộ trình chuyển đổi từ Centralized Data Platform sang Data Mesh | 10. Những sai lầm phổ biến và khi nào nên áp dụng Data Mesh | Kết luận

**1. Bối cảnh & vấn đề mở đầu**
Sau các bài về Ingestion/CDC, Lakehouse/Medallion, Orchestration, Data Quality/Data Contract/Modeling, Semantic Layer/Data Product/Governance và Observability, platform đã “tương đối hoàn chỉnh”. Nhưng ở quy mô doanh nghiệp, câu hỏi mới xuất hiện: *Ai thực sự chịu trách nhiệm đối với dữ liệu?*

Tác giả giả định 20 Business Domains, 100 hệ thống nguồn, 2.000 pipelines, 5.000 datasets và 300 Data Products, tất cả đổ về một Centralized Data Platform. Một đội Data Engineering trung tâm lo hết: kết nối nguồn, pipeline, làm sạch, xây DW, phục vụ báo cáo và xử lý DQ. Ban đầu mô hình này chạy tốt, nhưng dần thành điểm nghẽn:
- Thêm dữ liệu phải tạo yêu cầu gửi Data Team.
- Đổi một metric phải chờ Data Team cập nhật transformation.
- Pipeline lỗi thì Data Team phải đi làm việc với hệ thống nguồn.

Trong khi đó, những người hiểu nghĩa nghiệp vụ của dữ liệu lại không trực tiếp chịu trách nhiệm cung cấp dữ liệu cho hệ thống phân tích.

**2. Luận điểm cốt lõi**
Data Mesh không chỉ là phân tán dữ liệu. Nó thay đổi cách thiết kế platform, cách tổ chức đội ngũ và cách chia trách nhiệm:
- Business Domain sở hữu và công bố Data Product.
- Platform trở thành nền tảng self-serve.
- Governance được liên bang hóa (federated) và tự động hóa để giữ khả năng liên thông, tránh Data Silo mới.

Data Mesh bổ sung chứ không thay thế DW, Lakehouse hay Medallion, và không bắt buộc với mọi doanh nghiệp.

**3. Khái niệm chính**
- **Data Mesh:** cách tiếp cận kiến trúc và tổ chức để quản lý dữ liệu phân tán, trong đó việc sở hữu và cung cấp dữ liệu được chia theo Business Domain. Zhamak Dehghani giới thiệu năm 2019, sau đó phát triển thành hệ nguyên tắc.
- **Bốn nguyên tắc (Hình 2):**
  - Domain-oriented Ownership: Domain chịu trách nhiệm dữ liệu của mình.
  - Data as a Product: cung cấp dữ liệu như một sản phẩm có cam kết chất lượng.
  - Self-Serve Data Platform: platform cung cấp năng lực dùng chung.
  - Federated Computational Governance: governance thống nhất, thực thi bằng chính sách và tự động hóa.
- **Business Domain:** phạm vi nghiệp vụ có ranh giới, trách nhiệm và ngôn ngữ tương đối rõ. Chia theo nghiệp vụ, không theo công nghệ.
- **Domain Ownership khác Database Ownership:**
  - Domain Ownership là quyền và trách nhiệm với *ngữ nghĩa, chất lượng, vòng đời và cách cung cấp* dữ liệu, không phải sở hữu database vật lý.
  - Một hệ thống có thể chứa dữ liệu của nhiều Domain.
  - Dữ liệu của một Domain có thể nằm trên nhiều hệ thống.
- **Data Product và Dataset:**
  - Data Product là đơn vị cung cấp dữ liệu chính giữa các Domain.
  - Ngoài bảng dữ liệu, nó có đủ metadata để consumer tìm thấy, hiểu, tin tưởng và sử dụng.
  - Nó được thiết kế cho consumer, không phản chiếu cấu trúc nguồn.
- **Self-Serve Data Platform:** nền tảng dùng chung để các Domain không phải tự xây lại cùng một năng lực kỹ thuật. Tinh thần: “phân tán ownership, không phân tán toàn bộ hạ tầng”.
- **Platform Team:** người tạo điều kiện (enabler). Họ cung cấp công cụ, hạ tầng, khả năng vận hành và tiêu chuẩn kỹ thuật, nhưng không quyết định nghĩa nghiệp vụ.
- **Federated Governance:** gồm Global Governance (tiêu chuẩn chung của doanh nghiệp) và Domain Governance (Domain tự định nghĩa và quản lý trong phạm vi của mình).
- **Computational Governance / Policy as Code:** chính sách được kiểm tra tự động khi deploy. Chúng là các guardrail thay cho phê duyệt thủ công từng yêu cầu.
- **Data Silo:** hệ quả khi phân tán mà không có tiêu chuẩn chung.
- **Cross-domain Data Product:** sản phẩm phụ thuộc nhiều Domain.
- **Authoritative metric:** khi một chỉ tiêu có nhiều định nghĩa hợp lệ, cần xác định định nghĩa nào là chính thức cho từng mục đích.
- **Operating model:** Data Mesh là thay đổi mô hình vận hành, không chỉ là một sơ đồ kiến trúc.

**4. Kiến trúc, pattern & quy trình**
- **Mô hình tập trung (Hình 1):** `Source Systems (Trading, Banking, CRM, ERP, Risk) → Central DE Team (Ingestion, Transformation, Data Quality) → Centralized Data Lake/DW (Storage, Data Models, Analytics Datasets) → BI & Reports | Analytics | AI/ML`.
- **Luồng yêu cầu gây nghẽn:** `Trading Team → Submit Requirement → Central Data Team → Analyze Source → Develop Transformation → DQ Testing → Deploy Pipeline → Update BI Report`.
- **Ownership mơ hồ:** Source Team sở hữu Application, Data Team sở hữu Analytical Data, Business Team tiêu thụ Reports. Khi dữ liệu sai:
  - Source Team cho rằng dữ liệu đã ghi nhận đúng.
  - Data Team cho rằng pipeline xử lý đúng logic.
  - Business Team lại thấy báo cáo không chính xác.
- **Kiến trúc Mesh tổng thể (Hình 5), ba tầng trao đổi hai chiều:**
  - Business Domains: Trading (Trade Products), Margin (Loan Products), Risk (Risk Products).
  - Shared Self-Serve Data Platform: Ingestion & CDC, Storage & Compute, Pipeline Orchestration, Data Catalog & Lineage, Quality & Observability, Security & Access Control.
  - Federated Governance: Global Policies, Contracts, Standards, Compliance.
  - Phân vai: Domain sở hữu Data Product và logic nghiệp vụ; Platform Team cung cấp công cụ, hạ tầng và vận hành; Governance đặt luật chung cho mọi Domain.
- **Quy trình self-service tạo Data Product:** `Create → Select Product Template → Configure Source & Schema → Provision Storage/Compute → Configure DQ → Configure Access Policies → Register Data Catalog → Deploy`. Được hỗ trợ bằng template, API, Infrastructure as Code và workflow automation.
- **Cổng kiểm soát governance khi deploy:** `Deployment → Schema Validation → Data Classification Check → PII Policy Check → Data Contract Validation → Quality Test → Publish / Reject`.
- **Cách consumer lấy dữ liệu:**
  - Truyền thống: `Risk Team → Request SQL/Extract → DE Team → Trading Database`.
  - Data Mesh: `Trading Domain → Executed Trades Data Product → Data Catalog → Risk Domain`.
  - Trong Mesh, Risk tự tìm sản phẩm, đọc metadata, kiểm SLA và xin quyền qua cơ chế chuẩn. Trading vẫn chịu trách nhiệm sản phẩm đã công bố.
- **Kết hợp với Lakehouse:**
  - Ví dụ: Trading Domain có Trading Lakehouse và Trading Data Products; Margin Domain có Margin Lakehouse và Margin Data Products; Risk Domain có Risk Data Products.
  - Các Domain có thể dùng chung một Lakehouse Platform với cô lập logic (logical isolation) và quản trị tài nguyên.
  - Không cần mỗi Domain một cụm Spark hay một Object Storage riêng.
- **Kết hợp với Medallion:**
  - Ví dụ: `Trading Domain → Bronze → Silver → Gold → Trading Data Products`.
  - Không phải sản phẩm nào cũng cần đủ ba lớp: một sản phẩm sự kiện dạng stream có thể publish thẳng từ processing pipeline khi đã đạt yêu cầu schema, chất lượng và bảo mật.
- **Đổi vai trò:** trước đây Central Team tự xây mọi pipeline; nay Platform Team tạo điều kiện để các Domain tự xây và vận hành Data Product.
- **Hai mô hình ở phần kết luận:**
  - Tập trung: `Central Data Team → Collect → Transform → Serve → Business Consumers`.
  - Mesh: `Business Domains → Own & Publish Data Products → Shared Self-Serve Platform → Cross-domain Consumption → Analytics/BI/AI`, với Federated Governance áp dụng cho mọi Domain.

**5. Framework ra quyết định & so sánh**

Centralized và Data Mesh (Hình 8). Tác giả lưu ý đây là xu hướng, không phải quy tắc tuyệt đối: một platform tập trung vẫn có thể trao ownership cho Domain và áp dụng self-service.

| Tiêu chí | Centralized | Data Mesh |
|---|---|---|
| Data Ownership | Chủ yếu thuộc Central Data Team | Chia theo Business Domain |
| Data Engineering | Tập trung | Năng lực ở cấp Domain, có Platform hỗ trợ |
| Data Product | Thường do nhóm trung tâm làm | Domain chịu trách nhiệm |
| Infrastructure | Tập trung | Có thể dùng chung hoặc phân tán |
| Governance | Chủ yếu tập trung | Federated và tự động hóa |
| Business Knowledge | Phải chuyển giao cho Data Team | Gắn trực tiếp với Domain |
| Scaling | Phụ thuộc năng lực nhóm trung tâm | Mở rộng theo năng lực các Domain |

Global và Domain Governance (Hình 7):

| Lĩnh vực | Global | Domain |
|---|---|---|
| Data Classification | Quy định phân loại dữ liệu | Gán nhãn dataset |
| Data Quality | Tiêu chuẩn kiểm thử tối thiểu | Quy tắc chất lượng nghiệp vụ |
| Access Control | Chính sách bảo mật chung | Phê duyệt quyền theo thẩm quyền |
| Schema Management | Quy tắc tương thích và version | Quản lý schema sản phẩm |
| Data Retention | Chính sách và yêu cầu pháp lý | Áp dụng thời hạn phù hợp |
| Data SLA | Khung quản lý và theo dõi | Cam kết cho từng sản phẩm |

Ma trận mức độ phù hợp (Hình 12). Ngay cả ô cuối cùng, Mesh cũng không mặc nhiên là lựa chọn tốt nhất; cần cân nhắc năng lực tổ chức, chi phí chuyển đổi và khả năng duy trì governance.

| Quy mô & tự chủ Domain | Nhu cầu chia sẻ thấp | Nhu cầu chia sẻ cao |
|---|---|---|
| Nhỏ, ít Domain | Centralized Data Platform | Centralized Platform + Data Product Standards |
| Lớn, nhiều Domain | Domain Ownership + Shared Platform | Đánh giá áp dụng Data Mesh đầy đủ |

- **Khi nào chưa cần Mesh:** 5 hệ thống nguồn, 1 đội DE, 20 báo cáo BI và vài analytical workload. Một Centralized Lakehouse với ownership rõ ràng là đủ.
- **Khi nào đáng cân nhắc Mesh:**
  - Nhiều Business Domain độc lập.
  - Hàng trăm nguồn dữ liệu.
  - Nhiều consumer dùng dữ liệu liên Domain.
  - Nhu cầu Data Product cao.
  - Các delivery team độc lập.
  - Yêu cầu governance phức tạp.
- **Lakehouse và Mesh không đối lập:**
  - Lakehouse trả lời: dữ liệu được lưu, xử lý và phục vụ analytics thế nào.
  - Mesh trả lời: ai sở hữu, ai cung cấp, các Domain phối hợp ra sao.
  - Mesh không phải công nghệ lưu trữ; DW và Lakehouse vẫn giữ vai trò quan trọng.
- **Medallion và Mesh:** Medallion tổ chức theo mức độ xử lý, Mesh tổ chức ownership theo Domain. Hai cách kết hợp được; Medallion là pattern hữu ích chứ không bắt buộc.
- **Ưu điểm của mô hình tập trung:**
  - Hạ tầng tập trung, dễ chuẩn hóa công nghệ.
  - Dễ kiểm soát chi phí ở giai đoạn đầu.
  - Không cần đội DE cho từng phòng ban.
  - Có một nguồn dữ liệu chung cho báo cáo toàn doanh nghiệp.
  - Đây “không phải kiến trúc sai”; chỉ gặp vấn đề khi phạm vi vượt khả năng mở rộng của đội trung tâm.
- **Metric dùng chung nhưng khác nghĩa:** không ép hai Domain dùng chung một metric khi ngữ nghĩa khác nhau. Thay vào đó:
  - Ghi rõ định nghĩa và owner của từng metric.
  - Xác định chỉ tiêu nào là chính thức cho từng mục đích.
  - Chuẩn hóa định danh và quy tắc đối soát khi cần.
  - Công bố qua Semantic Layer hoặc Data Product phù hợp.
  - Ngược lại, Mesh cũng không cho phép mỗi Domain tự định nghĩa lại metric dùng chung mà không phối hợp.

**6. Best practices / nguyên tắc thiết kế**
- Chia Domain theo nghiệp vụ, không theo công nghệ (Oracle, PostgreSQL, Kafka, Data Lake).
- Domain không chỉ bàn giao raw data mà phải công bố Data Product đạt chuẩn chung. Với mỗi sản phẩm, Domain phải trả lời được:
  - Dữ liệu có ý nghĩa gì? Ai là owner?
  - Cập nhật với tần suất nào? Thay đổi schema được quản lý ra sao?
  - Có đáp ứng cam kết chất lượng không? Consumer dùng qua giao diện nào?
- Trách nhiệm nghiệp vụ thuộc Domain, còn kỹ năng kỹ thuật có thể đến từ Data Engineer làm cùng Domain hoặc một đội hỗ trợ. Business Team không buộc phải tự viết Spark job hay vận hành Kafka.
- **Sáu đặc tính của Data Product tốt (Hình 4):**

| Đặc tính | Ý nghĩa |
|---|---|
| Discoverable | Tìm được qua Data Catalog |
| Addressable | Có định danh và giao diện truy cập rõ ràng |
| Self-describing | Có metadata và mô tả nghiệp vụ |
| Trustworthy | Có cam kết chất lượng và trạng thái vận hành |
| Interoperable | Kết hợp được với dữ liệu Domain khác |
| Secure | Có chính sách truy cập và bảo vệ dữ liệu |

- **Self-service phải thật sự tự động:** nếu Domain vẫn phải tạo ticket chờ cấp tài nguyên thủ công thì mới chỉ là chia sẻ hạ tầng.
- **Platform giữ những năng lực có thể cung cấp hiệu quả dưới dạng dịch vụ dùng chung.**
- **Governance hai cấp, thực thi bằng Policy as Code.** Policy mẫu yêu cầu:
  - Metadata bắt buộc: owner, domain, classification, schema_version.
  - Mã hóa PII; từ chối truy cập trái phép.
  - Bắt buộc kiểm tra Data Contract.
  - Bắt buộc theo dõi freshness.
- Chuẩn hóa các định danh dùng chung giữa các Domain.
- Dùng Data Lineage và Data Contract để phân định trách nhiệm trong sản phẩm liên Domain.
- Chuyển đổi từng bước: làm rõ trách nhiệm trước khi đổi hạ tầng. Đo mức độ sử dụng thực tế, không chỉ đếm số Data Product.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Data Team tự suy luận nghiệp vụ từ database schema → dữ liệu sai về business dù pipeline chạy thành công.
- Ownership mơ hồ, các đội đùn đẩy trách nhiệm khi số liệu sai.
- Chia Domain theo công nghệ, hoặc coi Domain đồng nghĩa với database vật lý.
- **Nhầm Mesh với việc chia nhỏ DW** (Warehouse A cho Trading, B cho Margin, C cho Risk). Nếu không có ownership, contract, catalog và governance chung thì đó chỉ là phân tán hạ tầng. Mesh không được định nghĩa bằng số lượng DW.
- **Phân tán Data Engineering mà không có Platform Team:** mỗi Domain tự dựng Kafka, Airflow, Spark, monitoring stack và security framework → chi phí và độ phức tạp tăng rất nhanh.
- **Gán ownership mà không trao nhân sự, ngân sách hay quyền quyết định.**
- **Để Domain tự quyết mọi tiêu chuẩn** (đặt tên, định danh khách hàng, phân loại, bảo mật) → Mesh có thể biến thành một mạng lưới Data Silo.
- **Chuyển đổi toàn bộ quá sớm** khi chưa có Data Catalog, Data Contract, DQ và pipeline automation ổn định. Mesh không thay thế các năng lực nền tảng đó mà phụ thuộc rất nhiều vào chúng.
- **Áp dụng Mesh cho doanh nghiệp chưa cần.**
- Self-service “giả” vẫn qua ticket; governance chỉ nằm trên giấy.
- Chia ngay toàn bộ Central DW thành nhiều hệ thống nhỏ.
- Tạo hàng trăm Data Product mà không ai dùng.

**8. Ví dụ minh họa (công ty chứng khoán)**
- **Bản đồ Domain (Hình 3):**

| Domain | Phạm vi dữ liệu |
|---|---|
| Trading | Lệnh, giao dịch, khớp lệnh |
| Customer | Khách hàng, tài khoản, phân khúc |
| Margin | Khoản vay, dư nợ, tài sản bảo đảm |
| Risk | Hạn mức, rủi ro, cảnh báo |
| Finance | Doanh thu, chi phí, kế toán |
| Market Data | Giá chứng khoán, dữ liệu thị trường |

  Trading định nghĩa thế nào là giao dịch hợp lệ; Margin định nghĩa dư nợ và hạn mức cho vay; Finance sở hữu các định nghĩa kế toán chính thức.
- **Những câu hỏi nghiệp vụ Data Engineer có thể không trả lời được:**
  - Giao dịch nào được coi là khớp lệnh thành công?
  - Giao dịch sửa hoặc hủy được phản ánh thế nào?
  - Dư nợ Margin được xác định tại thời điểm nào?
  - Số dư tiền mặt có gồm tiền chờ về không?
  - P&L tính theo giá vốn nào?
- **Metric mới “Daily Net Trading Value”** phải xếp hàng qua 7 bước của đội trung tâm.
- **Trading Domain trải trên nhiều hệ thống:**
  - Dữ liệu nằm ở Oracle Core Trading, Kafka Trade Events, PostgreSQL Order Service và Historical Trade Dataset.
  - Domain công bố Order Events, Executed Trades, Daily Trading Summary và Trading Volume Metrics.
- **Data Product manifest (YAML minh họa, không phải schema chuẩn của công cụ nào)** cho `trading-executed-orders`:
  - Định danh: domain trading, version 1.2.0, owner `trading-data` kèm email liên hệ, schema dạng parquet.
  - Cam kết: freshness 5 phút, availability 99,9%; không có `trade_id` null hay trùng; classification confidential.
  - Truy cập: qua SQL, cần phê duyệt.
- **Phân mảnh định danh:** Trading dùng `customer_id`/`trade_date`; Margin dùng `cust_code`/`business_day`; Risk dùng `account_reference`/`transaction_date`.
- **Kiến trúc truyền thống:**
  - Luồng: `Oracle Trading + PostgreSQL CRM + Margin DB + Risk System + Accounting DB → Central ETL → DW → BI/Reports`.
  - Muốn có chỉ tiêu mới, Risk phải phối hợp với Data Team để gom dữ liệu từ Trading, Margin và Customer.
- **Kiến trúc Mesh đề xuất (Hình 9):**
  - Các Domain công bố sản phẩm: Trading (Executed Trades, Order Events), Customer (Customer Profile, Account), Margin (Loan Balance, Collateral), Market Data (Security Prices, Reference).
  - Risk Domain tiêu thụ các sản phẩm này để tạo Portfolio Risk Exposure, phục vụ Risk Dashboard, Regulatory Reports và AI Risk Analytics.
  - Bên dưới là Shared Platform & Federated Governance: Catalog, Contracts, Quality, Security, Observability, Compute.
- **Các Data Product cụ thể:**
  - `executed_trades`: trade_id, account_id, symbol, quantity, price, trade_timestamp, status.
  - `margin_exposure`: dư nợ, giá trị tài sản bảo đảm, các chỉ tiêu exposure theo tài khoản và thời điểm.
  - `portfolio_risk_exposure`: tổng hợp giao dịch, dư nợ và giá thị trường để phân tích rủi ro danh mục.
- **Sản phẩm liên Domain:**
  - Luồng: `Trading.executed_trades + Margin.margin_exposure + MarketData.security_prices → Risk.portfolio_risk_exposure`.
  - Mỗi Domain chịu trách nhiệm phần dữ liệu mình công bố; Risk chịu trách nhiệm logic tổng hợp.
  - Khi số liệu cuối sai, dựa vào Lineage và Data Contract để xác định lỗi nằm ở nguồn hay ở transformation của Risk.
- **Metric dùng chung:** Trading quan tâm “Trading Fee Estimate”, Finance quan tâm “Recognized Brokerage Revenue”. Hai chỉ tiêu khác nhau là hợp lý do khác phương pháp và thời điểm ghi nhận.

**9. Công nghệ/công cụ được nhắc tới**
- **Nguồn dữ liệu:** Oracle Core Trading, PostgreSQL (Order Service, CRM), Margin DB, Risk System, Accounting DB, Kafka Trade Events. Dùng để minh họa rằng dữ liệu một Domain nằm trên nhiều hệ thống.
- **Kỹ năng DE:** SQL, Spark, Airflow, Kafka, CDC, Data Warehouse. Domain không bắt buộc phải tự vận hành các công cụ này.
- **Lưu trữ dùng chung:** Lakehouse, Warehouse, Object Storage, với cô lập logic theo Domain.
- **Data Catalog:** tìm kiếm, metadata, ownership. **Lineage:** phân định trách nhiệm giữa các Domain.
- **Tự động hóa:** Infrastructure as Code, template, API, workflow automation. **Governance:** Policy as Code / policy engine.
- **Bảo mật:** IAM, RBAC/ABAC, Data Masking. **CI/CD:** versioning, testing, deployment.
- **Chi phí:** Chargeback/Showback. **Semantic Layer:** kênh công bố metric dùng chung.
- **Năng lực Platform Team nên cung cấp (Hình 6):**

| Capability | Chức năng |
|---|---|
| Data Ingestion | Template Batch, CDC, Streaming |
| Data Processing | Spark, SQL Engine, Transformation Runtime |
| Data Storage | Lakehouse, Warehouse, Object Storage |
| Orchestration | Workflow Scheduling, Dependencies, Backfill |
| Data Catalog | Metadata, Discovery, Ownership |
| Data Quality | Quality Rules, Validation, Testing |
| Observability | Freshness, Volume, Reliability, Cost |
| Security | IAM, RBAC/ABAC, Data Masking |
| CI/CD | Versioning, Testing, Deployment |
| Cost Management | Resource Quota, Usage, Chargeback/Showback |

- **Tài liệu tham khảo:** các bài của Zhamak Dehghani năm 2019 và 2020, sách O’Reilly năm 2022, và một tài liệu năm 2024 về Federated Governance.

**10. Checklist / lộ trình chuyển đổi**
**Lộ trình 5 phase:**
1. **Xác định Domain và Ownership.**
   - Kiểm kê Business Domains, Source Systems, datasets hiện có, Data Owners, Data Consumers và Critical Data Flows.
   - Gán owner cho các dataset quan trọng (Hình 10, bảng dưới).
   - Chưa cần đổi hạ tầng; mục tiêu là làm rõ trách nhiệm.

| Data Product | Owner | Consumer |
|---|---|---|
| Executed Trades | Trading | Risk, Finance |
| Customer Profile | Customer | Trading, Risk |
| Margin Exposure | Margin | Risk |
| Portfolio Risk | Risk | Management, Compliance |

2. **Chuẩn hóa Data Product.**
   - Chọn dataset có giá trị cao và đủ nhiều consumer.
   - Mỗi sản phẩm tối thiểu có: Owner, Description, Schema, Access Interface, Data Contract, Quality Rules, SLO, Version.
3. **Xây Shared Self-Serve Platform.**
   - Cung cấp Product Templates, Automated Provisioning, Data Catalog, Pipeline CI/CD, DQ Framework, Access Management, Observability.
   - Mục tiêu: giảm tối đa bước thủ công khi Domain tạo và công bố sản phẩm.
4. **Thí điểm tiêu thụ liên Domain** (Trading + Margin + Market Data → Risk Exposure Product). Đánh giá:
   - Khả năng tìm và truy cập dữ liệu.
   - Tính nhất quán của định danh và schema.
   - Data Contract giữa producer và consumer.
   - Khả năng theo dõi lineage.
   - Cách xử lý khi upstream thay đổi.
   - Chi phí xử lý dữ liệu liên Domain.
5. **Mở rộng Federated Governance.**
   - Mở rộng sang các Domain khác; chuẩn hóa và tự động hóa thêm chính sách.
   - Theo dõi KPI chuyển đổi (Hình 11, bảng dưới).

| KPI | Đo gì |
|---|---|
| Data Product Adoption | Số consumer và mức độ sử dụng |
| Time to Publish | Thời gian công bố Data Product |
| Self-Service Rate | Tỷ lệ tác vụ xong mà không cần can thiệp thủ công |
| Data SLO Compliance | Tỷ lệ đáp ứng cam kết |
| Contract Violations | Số lỗi vi phạm Data Contract |
| Cross-domain Reuse | Mức tái sử dụng dữ liệu giữa các Domain |
| Cost per Data Product | Chi phí vận hành và cung cấp dữ liệu |

Các danh sách kiểm tra khác: câu hỏi Domain phải trả lời cho từng sản phẩm, policy manifest tối thiểu và sáu đặc tính Data Product (đều ở mục 6), cùng sáu sai lầm cần tránh (mục 7).

**11. Kết luận & key takeaways**
- Chuyển sang Mesh không phải là dời dữ liệu từ một kho sang nhiều kho, mà là thay đổi cả kiến trúc lẫn cách tổ chức trách nhiệm.
- Phải có đủ bốn trụ: Domain ownership, Data as a Product, Self-serve platform và Federated computational governance. Thiếu tiêu chuẩn chung sẽ dẫn đến Data Silo.
- Mesh không thay Lakehouse, DW hay Medallion; nó tổ chức ownership và việc cung cấp dữ liệu trên nền các kiến trúc đó.
- Mesh không bắt buộc với mọi doanh nghiệp. Platform tốt là platform chia trách nhiệm hợp lý, cung cấp dữ liệu đáng tin cậy và mở rộng được cùng nhu cầu nghiệp vụ, chứ không phải dùng nhiều công nghệ nhất hay phân tán nhất.
- Vai trò của Platform đổi từ “nơi xử lý tất cả dữ liệu” thành “nền tảng để Domain tự cung cấp và quản lý Data Product”.
- Đo thành công bằng mức độ sử dụng và tái sử dụng, không bằng số lượng sản phẩm.
- Hai trích dẫn tiêu biểu:
  - “Ownership phải đi kèm năng lực thực thi, không chỉ là tên một phòng ban được gán vào metadata.”
  - “Data Mesh không loại bỏ Central Data Platform.”

**12. Liên kết với các bài khác**
- **Các bài trước:** phần mở đầu tóm lại Ingestion/CDC/Streaming, Lakehouse/Medallion, Orchestration và Metadata-driven, DQ/Data Contract/Modeling, Semantic Layer/Data Product/Governance và Observability.
- **Bài 11 (Data Product Design & Lifecycle):** ở Bài 14, Data Product được nâng lên thành đơn vị trao đổi dữ liệu giữa các Domain.
- **Bài 13:** Observability (Freshness, Volume, Reliability, Cost) trở thành năng lực của Shared Platform; policy bắt buộc freshness monitoring; Lineage được dùng để phân định trách nhiệm.
- **Data Contract:** nằm trong cổng kiểm soát khi deploy.
- **Semantic Layer:** kênh công bố metric dùng chung.
- **Bài 15:** “Data Platform Operations – Từ Data Observability đến Performance, Cost & Operational Intelligence”. Khi Data Product đã chia theo Domain trên Shared Platform, bài toán tiếp theo là vận hành cả hệ sinh thái: hiệu năng, tài nguyên, chi phí, SLA/SLO, sự cố và tối ưu ở quy mô doanh nghiệp.

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **Chạy được về kỹ thuật chưa có nghĩa là đúng về nghiệp vụ.** Bài 13: pipeline SUCCESS nhưng thiếu 120.000 records hoặc dữ liệu stale. Bài 14: pipeline đúng nhưng định nghĩa sai khi Data Team tự suy luận nghiệp vụ từ schema.
- **Data Product là đơn vị trung tâm của trách nhiệm và đo lường.** Bài 13 đo reliability, SLO và Error Budget tại Data Product. Bài 14 dùng Data Product làm đơn vị trao đổi giữa các Domain, có owner, contract, SLO, version và KPI về adoption.
- **Ownership và metadata chuẩn hóa là nền móng.** Bài 13 dùng định danh chung (domain, data_product, run_id, criticality) để liên kết telemetry. Bài 14 bắt buộc metadata qua policy và chuẩn hóa định danh để chống Data Silo. Ownership phải đi kèm năng lực và quyền hạn.
- **Lineage không chỉ là tài liệu.** Bài 13 dùng lineage cho impact analysis, blast radius và RCA. Bài 14 dùng lineage cùng Data Contract để phân định trách nhiệm giữa các Domain.
- **Tự động hóa phải có guardrail và con người phê duyệt hành động rủi ro.** Bài 13: remediation cần idempotency, audit và approval; AI chỉ đề xuất. Bài 14: self-service bằng template/IaC; governance bằng Policy as Code thay cho phê duyệt thủ công.
- **Thực dụng và đi theo mức trưởng thành, không chạy theo công cụ.** Bài 13 có maturity model 5 level và khuyên tận dụng stack sẵn có. Bài 14 có lộ trình 5 phase, ma trận mức độ phù hợp, và khẳng định không phải doanh nghiệp nào cũng cần Data Mesh. Cả hai đều tập trung năng lực nền tảng ở platform dùng chung, còn trách nhiệm nghiệp vụ thì giao cho Domain.


---

## Bài 15: Production-Ready Data Platform – Security, Reliability, Scalability & Cost Optimization
*Subtitle: "Làm thế nào để biết dữ liệu có được cập nhật đúng giờ, pipeline có hoạt động ổn định và khi sự cố xảy ra, chúng ta có thể nhanh chóng xác định nguyên nhân?" · Đăng 2026-10-15 · 10 hình/bảng*

[Ghi chú] Tiêu đề nhắc tới Security, Reliability, Scalability và Cost Optimization, nhưng thân bài gần như chỉ nói về **Data Observability và vận hành**. Bài không có mục riêng về Security. Cost chỉ xuất hiện qua "Cost Monitoring" (Giai đoạn 3) và việc theo dõi dung lượng storage. Bài 16 cũng gọi lại bài này là bài về "Data Observability".

Mục lục (H2): 1. Data Observability là gì và khác Monitoring thế nào? | 2. Nên giám sát những gì trong Data Platform? | 3. Pipeline Monitoring – Không chỉ kiểm tra Success và Failed | 4. Data Freshness – Dữ liệu có được cập nhật đúng giờ không? | 5. Data Volume & Processing Duration – Phát hiện những bất thường đơn giản | 6. Infrastructure Monitoring – Tận dụng những công cụ đang có | 7. Alerting – Cảnh báo đúng vấn đề, đúng người | 8. Metadata & Data Lineage – Biết lỗi ảnh hưởng đến đâu | 9. Xử lý sự cố – Tập trung vào Runbook và khả năng khôi phục | 10. Lộ trình triển khai Data Observability phù hợp với doanh nghiệp | Kết luận

**1. Bối cảnh & vấn đề mở đầu**
- Platform đã có Ingestion, Lakehouse, Medallion, Airflow, Data Quality/Data Contract và Data Product/Data Mesh. Khi đưa lên Production, câu hỏi mới xuất hiện: *"Làm sao biết Data Platform đang hoạt động tốt?"*
- Doanh nghiệp giả định có 10 source systems, 50 pipelines, 100 datasets và 20 BI reports, với luồng `Oracle/PostgreSQL/SQL Server → Airflow/Kafka → Spark/SQL → Lakehouse → BI/Reporting`.
- Sau một thời gian vận hành, các sự cố bắt đầu xuất hiện:
  - Airflow báo success nhưng dữ liệu chưa được cập nhật.
  - Pipeline thường chạy 5 phút nay mất 40 phút.
  - Kafka vẫn chạy nhưng xử lý chậm.
  - Một bảng trong Lakehouse 2 ngày không có dữ liệu mới.
  - Báo cáo buổi sáng thiếu dữ liệu mà không có cảnh báo.
  - Storage tăng nhanh không rõ nguyên nhân.

**2. Luận điểm cốt lõi**
Không cần dựng một Observability Platform phức tạp. Mục tiêu thực tế là có **đủ thông tin để phát hiện, xác định nguyên nhân và xử lý sự cố**. Cách làm là mở rộng monitoring sẵn có sang giám sát trạng thái *dữ liệu*, bắt đầu từ các pipeline/dataset quan trọng, cảnh báo đúng người và có runbook để khôi phục.

**3. Khái niệm chính**
- **Monitoring**: cho biết thành phần kỹ thuật còn chạy hay không (DAG SUCCESS, Spark COMPLETED, Kafka RUNNING, PostgreSQL HEALTHY). Nó không bảo đảm dữ liệu cuối cùng đã sẵn sàng cho người dùng.
- **Data Observability**: giám sát những đặc điểm của dữ liệu mà infrastructure monitoring chưa phản ánh được. Đây không phải một hệ thống tách biệt mà là phần mở rộng của monitoring hiện có.
- **Data Freshness**: độ mới của dữ liệu so với thời điểm mong đợi. Tác giả coi đây là chỉ số quan trọng nhất, vì người dùng chỉ hỏi "dữ liệu hôm nay đã có chưa".
  - Cần phân biệt *độ trễ quan sát được* với *vi phạm cam kết*.
  - Muốn biết có vi phạm hay không thì phải so với thời hạn cập nhật đã định nghĩa.
- **Data Volume**: so số bản ghi với baseline lịch sử (độ lệch %).
- **Processing Duration**: so thời gian chạy với mức bình thường.
- **Run metrics**: `rows_read`, `rows_written`, `last_watermark`, `duration`, ghi bổ sung bên cạnh trạng thái success/failed.
- **Consumer Lag**: hữu ích vì Kafka broker có thể vẫn "khỏe" trong khi consumer xử lý không kịp.
- **Metadata/Lineage table**: bảng pipeline–source–target–consumer, dùng để biết lỗi ảnh hưởng tới đâu.
- **Runbook**: tài liệu quy trình xử lý sự cố. Theo tác giả, nó thường có giá trị thực tế hơn một hệ thống "AI Root Cause Analysis" phức tạp.
- **Mức độ cảnh báo**: Critical / Warning / Info.
- **Trading Calendar**: lịch giao dịch, dùng để tránh cảnh báo sai vào ngày nghỉ hoặc ngoài giờ giao dịch.

**4. Kiến trúc, pattern & quy trình**
- **Ghi run log có kết quả xử lý.** Ví dụ JSON: `customer_incremental`, success, 120s, rows_read 15000, rows_written 14980, last_watermark `2026-10-22T10:00:00`.
  - Log này trả lời được: chạy lúc nào, xong chưa, đọc/ghi bao nhiêu bản ghi, watermark đang ở đâu.
  - Airflow vốn đã có DAG/Task Status, Start/End Time, Execution Duration, Retry Count và Task Logs.
- **Kiểm tra freshness bằng SQL.** Dùng `MAX(updated_at)`, kèm `COUNT(*)`, trên `silver.trading_orders`.
  - Với bảng lớn, cần cân nhắc hiệu năng truy vấn.
  - Có thể ghi timestamp cập nhật cuối và số bản ghi vào bảng metadata riêng sau mỗi lần xử lý.
- **Lineage chain:** `Oracle Trading → trading_ingestion → bronze.trading → silver.trading → gold.trading_summary → Trading Dashboard`. Nếu ingestion lỗi, mọi downstream đều có thể trễ.
- **Cây chẩn đoán "Dataset Stale":** `Check Airflow DAG → [Failed → Check Logs] | [Success → Check Records → Check Watermark → Check Source Data]`.
- **Tự động hóa việc đơn giản trước:**
  - `Pipeline Failed → Automatic Retry → Success → Finish | Failed → Send Alert`.
  - `Freshness Check → Exceeded Threshold? → No → Continue | Yes → Send Alert`.
  - Có thể làm bằng Airflow, cron, script Python hoặc công cụ automation sẵn có.
- **Cách tiếp cận tổng thể:** `Start Small → Monitor Critical Pipelines → Track Data Freshness → Centralize Alerts → Document Recovery Procedures → Improve Gradually`.

**5. Framework ra quyết định & so sánh**

Monitoring và Data Observability (Hình 1):

| Monitoring | Data Observability |
|---|---|
| Pipeline có chạy không? | Dữ liệu có đến đúng giờ không? |
| Task có lỗi không? | Dữ liệu có được cập nhật không? |
| Database có hoạt động không? | Dataset nào không có dữ liệu mới? |
| Spark có chạy thành công không? | Pipeline có chạy chậm bất thường không? |
| CPU, Memory bao nhiêu? | Sự cố ảnh hưởng đến dữ liệu nào? |

Năm nhóm nên giám sát trước (Hình 2):
- **Pipeline Status**: chạy thành công hay không.
- **Data Freshness**: có cập nhật đúng thời điểm không.
- **Data Volume**: số lượng có biến động bất thường không.
- **Processing Duration**: thời gian xử lý có tăng bất thường không.
- **Infrastructure Health**: Database, Kafka, Spark, Storage có ổn định không.

Bảng theo dõi pipeline mẫu (Hình 3):

| Pipeline | Status | Duration | Records | Last Run |
|---|---|---|---|---|
| customer_sync | Success | 2 phút | 15.000 | 10:00 |
| trading_sync | Success | 4 phút | 120.000 | 10:05 |
| margin_sync | Failed | 1 phút | 0 | 10:10 |
| market_price | Success | 12 phút | 8.000 | 10:15 |

Expected Freshness theo dataset (Hình 4, chỉ minh họa):

| Dataset | Expected Freshness |
|---|---|
| Trading Orders | 5 phút |
| Customer Master | 1 giờ |
| Margin Balance | 15 phút |
| Daily Accounting | Hằng ngày |
| Monthly Finance Report | Hằng tháng |

Processing Duration (Hình 5, biểu đồ đường, đơn vị phút): T2 ≈5, T3 ≈5,5, T4 ≈6, T5 ≈6,2, rồi **T6 ≈18**. Bước nhảy ở T6 là dấu hiệu cần kiểm tra.

Stack monitoring tham khảo (Hình 6):

| Nhu cầu | Công cụ |
|---|---|
| Metrics | Prometheus |
| Dashboard | Grafana |
| Logs | ELK hoặc Loki |
| Pipeline Monitoring | Airflow UI |
| Alerting | Grafana Alerting |
| Notifications | Email, Teams hoặc Telegram |

Các cảnh báo nên có (Hình 7):

| Alert | Điều kiện ví dụ |
|---|---|
| Pipeline Failed | Task thất bại sau retry |
| Pipeline Delayed | Chưa hoàn thành trước deadline |
| Dataset Stale | Không cập nhật đúng kỳ vọng |
| Volume Anomaly | Số bản ghi biến động mạnh |
| Kafka Consumer Lag | Lag vượt ngưỡng |
| Storage Capacity | Disk vượt ngưỡng cảnh báo |

Mức độ cảnh báo (Hình 8):

| Level | Ý nghĩa | Ví dụ |
|---|---|---|
| Critical | Ảnh hưởng trực tiếp tới nghiệp vụ quan trọng | Dữ liệu báo cáo bắt buộc không sẵn sàng |
| Warning | Có nguy cơ gây ảnh hưởng | Pipeline chạy chậm hơn bình thường |
| Info | Thông tin cần theo dõi | Job hoàn tất sau retry |

Metadata lineage tối giản (Hình 9):

| Pipeline | Source | Target | Consumer |
|---|---|---|---|
| trading_ingestion | Oracle Trading | bronze.trading | silver_trading |
| silver_trading | bronze.trading | silver.trading | trading_summary |
| trading_summary | silver.trading | gold.trading_summary | BI Dashboard |

Metric hạ tầng theo từng thành phần:
- **Database:** CPU, Memory, Disk Usage, Active Connections, Long-running Queries, Replication Lag. Cần đặc biệt theo dõi tác động của ingestion workload lên Production DB.
- **Kafka:** Broker Availability, Consumer Lag, Topic Throughput, Under-replicated Partitions, Disk Usage.
- **Spark:** Job Status, Job Duration, Executor Memory, CPU Utilization, Failed Stages, Shuffle. Khi job chậm, nên xem Spark UI và Event Logs trước.
- **Airflow:** DAG Success/Failed, Task Duration, Queued Tasks, Scheduler Health, Worker Health.

Các lựa chọn chính:
- Dùng ngưỡng đơn giản trước, chưa cần ML hay Anomaly Detection.
- Tận dụng PRTG, Zabbix hoặc ELK đang có, thay vì triển khai cùng lúc Prometheus, Grafana, Elasticsearch và OpenTelemetry.
- Lineage bắt đầu bằng bảng metadata và dependency trong Airflow. OpenLineage hoặc Data Catalog chuyên dụng để sau, khi hệ thống lớn hơn.
- Pipeline thử nghiệm không cần mức giám sát như pipeline phục vụ báo cáo nghiệp vụ hằng ngày.
- AI chỉ khi đã có đủ log, metrics, runbook; bắt đầu bằng truy vấn/giải thích, không tự can thiệp Production.

**6. Best practices / nguyên tắc thiết kế**
- Không giám sát mọi dataset ngay từ đầu. Ưu tiên dữ liệu phục vụ báo cáo, nghiệp vụ và vận hành hằng ngày.
- Bổ sung số liệu *kết quả xử lý* (rows read/written, watermark) bên cạnh trạng thái success/failed.
- Điều kiện cảnh báo phải phản ánh đặc điểm từng pipeline:
  - `rows_read = 0` có thể bình thường vào ngày nghỉ hoặc ngoài giờ giao dịch.
  - Với chứng khoán phải tính đến Trading Calendar.
- Kỳ vọng cập nhật phải được định nghĩa theo nghiệp vụ.
- Baseline volume phải tính đến mùa vụ, lịch nghiệp vụ và đặc điểm dữ liệu.
- Ưu tiên ngưỡng đơn giản, dễ hiểu, dễ bảo trì.
- Tích hợp vào hệ thống giám sát hiện có thay vì tạo thêm một nền tảng vận hành mới.
- Một alert tốt phải có đủ ngữ cảnh:
  - pipeline, environment, task lỗi, thời điểm lỗi, nội dung lỗi, link log;
  - nếu được, thêm tên Data Product hoặc báo cáo bị ảnh hưởng.
- Metadata phải được cập nhật cùng với thay đổi pipeline.
- Viết runbook. Retry/backfill không được tạo bản ghi trùng hoặc ghi đè sai.
- AI chỉ nên dùng khi đã đủ log, metrics và runbook. Bắt đầu bằng truy vấn và giải thích thông tin, không để AI tự can thiệp vào Production.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Đồng nhất "DAG SUCCESS" với "dữ liệu đã sẵn sàng". Bảng đích vẫn có thể không có bản ghi mới vì:
  - nguồn không phát sinh dữ liệu;
  - điều kiện lọc incremental sai;
  - watermark bị cập nhật sai;
  - pipeline đọc 0 bản ghi nhưng vẫn kết thúc thành công.
- Ngược lại, coi `rows_read = 0` lúc nào cũng là lỗi.
- Chỉ theo dõi xem process còn sống hay không.
- Phát quá nhiều cảnh báo khiến đội vận hành bỏ qua vấn đề quan trọng.
- Alert trống trơn kiểu "DAG FAILED".
- Gửi cảnh báo dữ liệu không cập nhật vào ngày nghỉ.
- Nhảy ngay vào ML, Self-healing Platform, AI Root Cause Analysis, AI-driven Ops hoặc Predictive Analytics.
- Dựng hệ thống Data Lineage lớn ngay từ đầu, hoặc để metadata trở thành tài liệu lỗi thời.
- Triển khai cùng lúc Prometheus, Grafana, Elasticsearch và OpenTelemetry.
- Để AI tự động can thiệp vào Production.
- Kỳ vọng tự dự đoán mọi sự cố hoặc tự phục hồi toàn bộ pipeline.
- Chạy `COUNT`/`MAX` trên bảng lớn mà không cân nhắc hiệu năng.

**8. Ví dụ minh họa**
- **`customer_daily_sync`**: Airflow báo SUCCESS sau 3 phút, nhưng bảng đích không có bản ghi mới.
- **`trading_transactions`**: kỳ vọng 5 phút cập nhật một lần, lần cuối lúc 10:00, hiện tại 10:30 → Freshness Delay 30 phút.
- **`trading_ingestion`**: bình thường 5 phút, lần này mất 18 phút.
- **`trading_orders`**: dữ liệu mới nhất lúc 10:00, hiện tại 10:20 → trễ 20 phút. Có vi phạm hay không còn tùy thời hạn đã cam kết.
- **Volume**: Thứ Hai 100,000, Thứ Ba 105,000, Thứ Tư 110,000, Thứ Năm 12,000 bản ghi. So với trung bình 105,000 thì lệch **−88,6%**. Nếu Thứ Năm là ngày giao dịch bình thường thì cần kiểm tra.
- **Nguyên nhân pipeline chạy chậm**:
  - dữ liệu nguồn tăng mạnh;
  - query kém hiệu quả;
  - database quá tải;
  - thiếu tài nguyên Spark;
  - mạng chậm;
  - tác vụ khác tranh tài nguyên.
- **Alert mẫu**: "Pipeline Failed – `trading_daily_sync` – Production – Failed Task: `load_silver` – 10:15 – Database connection timeout – link Airflow Log".
- **Runbook "Trading Dataset Not Updated"** (6 bước):
  1. Kiểm tra trạng thái DAG.
  2. Kiểm tra thời điểm cập nhật cuối của dataset.
  3. So sánh số bản ghi đầu vào và đầu ra.
  4. Kiểm tra watermark của lần chạy gần nhất.
  5. Kiểm tra kết nối và dữ liệu ở source.
  6. Quyết định retry hay backfill.
- **Use case AI về sau**:
  - "Tổng hợp các pipeline thất bại trong 24 giờ qua và nhóm theo nguyên nhân".
  - "Phân tích log của `margin_sync` và đề xuất hướng kiểm tra".

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle / PostgreSQL / SQL Server**: hệ thống nguồn; cần giám sát cả tải mà ingestion gây ra.
- **Apache Airflow**: điều phối pipeline.
  - Là nguồn dữ liệu monitoring sẵn có: trạng thái, duration, retry, logs.
  - Airflow UI và Airflow APIs dùng cho giám sát tập trung.
  - Dependency giữa task/DAG có thể dùng làm lineage sơ khai.
  - Có thể dùng để chạy auto-retry và freshness check.
- **Apache Kafka**: ingestion; chỉ số quan trọng là consumer lag.
- **Apache Spark**: xử lý; chẩn đoán bằng Spark UI và Event Logs.
- **Lakehouse, MinIO/S3, Trino**: các thành phần của platform cần được giám sát.
- **Prometheus**: metrics. **Grafana / Grafana Alerting**: dashboard và cảnh báo.
- **ELK hoặc Loki**: logs. **Email / Teams / Telegram**: kênh gửi thông báo.
- **PRTG, Zabbix, ELK**: công cụ sẵn có nên tận dụng.
- **OpenTelemetry**: không cần triển khai ngay.
- **OpenLineage / Data Catalog chuyên dụng**: để giai đoạn sau, khi hệ thống lớn hơn.
- **SQL, Python scripts, cron**: dùng cho các kiểm tra và tự động hóa đơn giản.
- **AI Assistant**: giai đoạn sau, hỗ trợ troubleshooting.
- **Tài liệu tham khảo**: tài liệu của Airflow, Prometheus, Grafana, OpenLineage và Spark Monitoring.

**10. Checklist / câu hỏi thiết kế**

Lộ trình 3 giai đoạn:

| Giai đoạn | Nội dung | Công cụ | Mục tiêu |
|---|---|---|---|
| 1 – Giám sát cơ bản | Pipeline Status, Duration, Data Freshness, Records Processed, Basic Alerting | Airflow, SQL, Python scripts, Email/Teams | Phát hiện pipeline lỗi, dữ liệu không cập nhật, bất thường dễ thấy |
| 2 – Giám sát tập trung (khi số pipeline tăng) | Centralized Dashboard, Infrastructure Metrics, Data Volume Monitoring, Basic Metadata/Lineage, Operational Runbooks | Prometheus/Grafana, ELK sẵn có, Airflow APIs, Metadata Tables | Không phải vào từng hệ thống để kiểm tra từng pipeline |
| 3 – Tối ưu vận hành (chỉ khi có nhu cầu thực tế) | Historical Baselines, Performance Analysis, Cost Monitoring, Impact Analysis, AI-assisted Troubleshooting | — | Không bắt buộc đạt tới mức tự dự đoán/tự phục hồi |

Minimum Data Observability Checklist (Hình 10, 8 mục):
1. Xác định danh sách pipeline và dataset quan trọng.
2. Thu thập trạng thái chạy, duration và số bản ghi xử lý.
3. Thiết lập kiểm tra Data Freshness.
4. Cảnh báo khi pipeline lỗi hoặc dữ liệu cập nhật trễ.
5. Có một dashboard theo dõi tập trung.
6. Ghi nhận source, target và owner của từng pipeline.
7. Viết runbook cho các sự cố thường gặp.
8. Theo dõi dung lượng storage và hiệu năng hệ thống.

Sáu câu hỏi nền tảng (phần Kết luận):
- Pipeline có chạy không?
- Dữ liệu có cập nhật đúng giờ không?
- Số lượng dữ liệu có bất thường không?
- Pipeline có chạy chậm hơn bình thường không?
- Khi có lỗi, ai là người xử lý?
- Làm thế nào để khôi phục?

**11. Kết luận & key takeaways**
- Platform không chỉ cần thiết kế tốt mà còn phải vận hành ổn định. Observability không nhất thiết phải bắt đầu từ AI-driven Ops, Predictive Analytics hay Automated RCA.
- Pipeline success không có nghĩa là dữ liệu đã sẵn sàng. Phải giám sát trạng thái dữ liệu, trong đó freshness được ưu tiên hàng đầu.
- Trả lời tốt 6 câu hỏi cơ bản đã cải thiện đáng kể khả năng vận hành.
- Thước đo không phải số dashboard hay số công cụ. Thước đo là khi có sự cố, đội vận hành phát hiện sớm, biết hướng điều tra, xác định được phạm vi ảnh hưởng và xử lý nhanh.
- Platform ổn định, có cảnh báo đúng và tài liệu xử lý rõ ràng đã là "một thành công đáng kể".
- Hai trích dẫn:
  - *"Nếu phải chọn một chỉ số quan trọng nhất để giám sát Data Platform, mình sẽ ưu tiên Data Freshness."*
  - *"Một Data Platform tốt không nhất thiết phải có hệ thống Observability phức tạp."*

**12. Liên kết với các bài khác**
- Mở đầu bằng phần tóm tắt các bài trước: Ingestion, Lakehouse, Medallion, Airflow, Data Quality & Data Contract, Data Product & Data Mesh. Bài này chuyển trọng tâm từ thiết kế sang vận hành.
- Dùng lại các khái niệm đã có:
  - watermark và incremental (các bài về ingestion);
  - retry, backfill, dependency (bài về orchestration);
  - chuỗi Bronze → Silver → Gold;
  - Data Product (alert nên ghi rõ Data Product bị ảnh hưởng).
- **Bài 16** (mục 8) đặt Observability vào kiến trúc end-to-end và nhắc thẳng "Trong Bài 15…".
- **Bài 17** (mục 9.2) dùng lại khái niệm freshness so với SLA, qua ví dụ dataset ở trạng thái STALE.

---

## Bài 16: End-to-End Reference Architecture – Kết nối tất cả thành phần của Modern Data Platform
*Subtitle: "Từ Data Ingestion, Lakehouse, Orchestration đến Data Quality, Semantic Layer, Data Products và Observability" · Đăng 2026-10-16 · 12 hình/bảng*

Mục lục (H2): 1. Bắt đầu từ bài toán nghiệp vụ, không phải công nghệ | 2. End-to-End Reference Architecture – Bức tranh tổng thể | 3. Data Ingestion – Đưa dữ liệu vào Platform như thế nào? | 4. Storage & Processing – Tổ chức Bronze, Silver và Gold | 5. Orchestration – Kết nối các bước xử lý thành Pipeline | 6. Data Quality & Governance – Đảm bảo dữ liệu đáng tin cậy | 7. Data Modeling, Semantic Layer và Data Products | 8. Data Observability – Khi hệ thống đã chạy, giám sát những gì? | 9. Reference Technology Stack – Lựa chọn công nghệ phù hợp với doanh nghiệp Việt Nam | 10. Implementation Roadmap – Triển khai theo từng giai đoạn | Kết luận

**1. Bối cảnh & vấn đề mở đầu**
- Series đã đi qua nhiều thành phần:
  - Ingestion: Batch, Incremental, CDC, Streaming.
  - Data Lake, Lakehouse, Data Warehouse.
  - Medallion Architecture.
  - Orchestration và Metadata-Driven Architecture.
  - Data Quality và Data Contract.
  - Data Modeling, Semantic Layer, Data Products.
  - Governance, Data Mesh, Observability.
- Câu hỏi đặt ra: *làm sao ghép tất cả thành một platform hoàn chỉnh, vận hành được trong doanh nghiệp?*
- Các reference architecture thường liệt kê rất nhiều công cụ: Kafka, Debezium, Airflow, Spark, Flink, Iceberg, Trino, dbt, Great Expectations, DataHub, Grafana, Prometheus… Doanh nghiệp nào cũng cần hết? "Chắc chắn là không."
- Một doanh nghiệp có vài chục database, vài trăm bảng, cần cập nhật mỗi 5–15 phút thì rất khác một hệ thống Internet phục vụ hàng triệu người dùng theo thời gian thực.
- Bài đặt 3 mục tiêu:
  1. Ghép các thành phần thành một kiến trúc end-to-end.
  2. Làm rõ vai trò và luồng hoạt động của từng thành phần.
  3. Đề xuất cách triển khai thực tế: bắt đầu nhỏ, mở rộng dần, phù hợp doanh nghiệp Việt Nam.
- Tác giả gọi đây là "bài cuối của phần kiến trúc".

**2. Luận điểm cốt lõi**
- Kiến trúc tham khảo không nhằm có đủ mọi tính năng Enterprise. Nó cần **"đủ đơn giản để triển khai, đủ ổn định để vận hành và đủ linh hoạt để phát triển"**.
- Điểm quan trọng nhất là tách được nơi phát sinh dữ liệu, nơi xử lý và nơi sử dụng dữ liệu, đồng thời giữ rõ vai trò của từng lớp.
- Công nghệ được chọn theo workload và nhu cầu thực tế, rồi mở rộng dần.

**3. Khái niệm chính**
- **5 lớp chính:**
  - Data Sources: nơi phát sinh dữ liệu gốc.
  - Data Ingestion: đưa dữ liệu về platform.
  - Storage & Transformation: lưu, làm sạch, chuẩn hóa, xây dữ liệu phân tích.
  - Data Serving: cung cấp dữ liệu đã chuẩn bị theo nhu cầu nghiệp vụ.
  - Data Consumers: BI, dashboard, ứng dụng, AI.
- **Cross-cutting capabilities** (Orchestration, Quality, Governance, Observability, Security): không nằm trên đường đi của mọi bản ghi nhưng điều phối và kiểm soát toàn bộ quá trình xử lý.
- **Bronze**: giữ dữ liệu gần trạng thái gốc, phục vụ truy vết và tái xử lý. **Silver**: dữ liệu đã chuẩn hóa. **Gold**: bảng/view thiết kế theo nhu cầu sử dụng.
- **Quarantine**: bảng chứa dữ liệu lỗi để xử lý sau, thay vì xóa không để lại dấu vết.
- **Dependency, Retry, Idempotency, Backfill**: 4 điểm orchestration phải thiết kế ngay từ đầu.
- **Reconciliation**: đối soát Gold với Source. Với ngành tài chính, việc này "thường quan trọng hơn" kiểm tra Null/Duplicate.
- **Governance "vừa đủ"**: một bảng quản lý dataset gồm owner, source, tần suất refresh.
- **Data Modeling**: thiết kế theo đối tượng phân tích, dạng fact/dim.
- **Semantic Layer**: định nghĩa metric dùng chung (definition, grain, filters, owner). Giai đoạn đầu có thể chỉ là SQL view hoặc mô hình tập trung trong công cụ BI; chưa cần semantic engine độc lập.
- **Data Product**: dataset có đủ 6 yếu tố — mục đích nghiệp vụ, Data Owner, cấu trúc và định nghĩa, quy tắc chất lượng, tần suất cập nhật, cơ chế truy cập.
- **Lightweight Data Platform** và **Lakehouse-Based Data Platform**: hai phương án triển khai.

**4. Kiến trúc, pattern & quy trình**
- **Luồng giá trị:** `Operational Systems → Centralized Data Platform → Trusted Business Datasets → Reports / Analytics / Applications / AI`.
- **Sơ đồ reference (Hình 2):**
  - `DATA SOURCES (Oracle · SQL Server · CRM · API/Files)`
  - `→ DATA INGESTION (Batch · Incremental · CDC nếu cần)`
  - `→ STORAGE & TRANSFORMATION (BRONZE Raw/Historical → SILVER Cleaned/Standardized → GOLD Business-Ready)`
  - `→ DATA SERVING (SQL Views · Semantic Models · Data Products)`
  - `→ DATA CONSUMERS (BI · Reports · Applications · AI)`
  - Dải xuyên suốt: Orchestration · Quality · Governance · Observability · Security.
  - Chú thích của sơ đồ: công cụ cụ thể có thể thay đổi, nhưng vai trò từng lớp phải rõ ràng.
- **Ingestion:**
  - Đọc theo cửa sổ thời gian, ví dụ `WHERE UPDATED_AT >= :start_time AND UPDATED_AT < :end_time` trên `CASH_TRANSACTION`.
  - Lưu kết quả, rồi **chỉ cập nhật checkpoint sau khi ghi thành công**.
  - Dùng CDC khi cần đồng bộ cả UPDATE/DELETE với độ trễ thấp mà không có cơ chế incremental phù hợp.
- **Bronze:**
  - Các bảng `bronze.customer/account/trade/cash_transaction`.
  - Metadata kỹ thuật: `source_system, ingestion_time, batch_id, source_updated_at`.
  - Với CDC, thêm operation type và thông tin thứ tự thay đổi.
- **Silver:**
  - Sửa kiểu dữ liệu sai hoặc không thống nhất; khử trùng lặp.
  - Chuẩn hóa mã khách hàng, ngày tháng, trạng thái.
  - Áp dụng quy tắc xử lý bản ghi cập nhật/xóa.
  - Chỉ kết hợp nhiều nguồn khi có yêu cầu rõ ràng.
- **Gold:**
  - Các bảng `gold.daily_trading_summary, customer_asset_summary, margin_exposure, branch_revenue`.
  - Ví dụ view `daily_trading_summary`: `SUM(trading_value)` và `COUNT(*)` từ `silver.trade`, nhóm theo `trade_date, branch_id`.
  - Khi khối lượng lớn, dùng bảng tổng hợp cập nhật incremental thay vì tính lại toàn bộ mỗi lần truy vấn.
- **Pipeline chuẩn (Hình 5):** `Extract Source Data (Oracle → Bronze) → Transform Silver (Clean/Standardize/Deduplicate) → Run Data Quality Checks (Null/Duplicate/Reconciliation) → Build Gold Dataset (Aggregate/Business Rules) → Publish Dataset (Ready for BI/Applications)`.
  - Ví dụ DAG Airflow: `ingest_customer → transform_customer → validate_customer → publish_customer`.
- **Observability trong E2E:**
  - Airflow: trạng thái workflow.
  - PostgreSQL: lưu lịch sử batch và kết quả quality check.
  - Grafana: metric. Elasticsearch: log tập trung.
  - Email/Teams/kênh nội bộ: cảnh báo.
- **Phương án A – Lightweight:**
  - Luồng: `Oracle/SQL Server → Python/SQL Ingestion → PostgreSQL Bronze → SQL Transformation → PostgreSQL Silver → Business Aggregation → PostgreSQL Gold → Power BI/Superset`.
  - Không phải Lakehouse theo nghĩa kỹ thuật chặt chẽ nếu mọi thứ nằm trong PostgreSQL, nhưng vẫn áp dụng Medallion và nhiều nguyên tắc của Modern Data Platform.
  - Dễ triển khai, dễ quản lý, không cần đội lớn.
- **Phương án B – Lakehouse-Based** (khi dữ liệu lớn hơn, cần lưu lịch sử dài hoặc tách storage khỏi compute):
  - Luồng: `Source Systems → Ingestion Pipelines → Object Storage (MinIO/S3) → Bronze/Silver/Gold (Iceberg) → Trino/SQL → BI/Analytics`.
  - Spark lo transformation nặng; Trino cung cấp SQL tương tác; Airflow điều phối theo lịch.
  - Cần thiết kế thêm Iceberg Catalog, quản lý metadata, phân quyền truy cập và vòng đời dữ liệu.
- **Hệ "vừa đủ" để khởi đầu:** `Reliable Ingestion + Structured Storage + Repeatable Transformation + Data Quality + Business-Ready Datasets + Basic Observability`.

**5. Framework ra quyết định & so sánh**

Hệ thống nguồn của ví dụ (Hình 1):

| Hệ thống | Dữ liệu | Công nghệ |
|---|---|---|
| Core Securities | Khách hàng, tài khoản, giao dịch | Oracle |
| Trading System | Lệnh và khớp lệnh | Oracle / SQL Server |
| CRM | Thông tin và chăm sóc khách hàng | PostgreSQL |
| Finance | Doanh thu, chi phí, công nợ | SQL Server |
| External Data | Giá chứng khoán, dữ liệu thị trường | API / CSV |

Phương thức ingestion theo loại dữ liệu (Hình 3; tần suất chỉ minh họa, không phải SLA chung):

| Loại dữ liệu | Phương thức | Tần suất |
|---|---|---|
| Danh mục chi nhánh | Full Batch | Hằng ngày |
| Thông tin khách hàng | Incremental | 15 phút |
| Giao dịch tiền | Incremental / CDC | 5 phút |
| Lệnh giao dịch | CDC nếu cần độ trễ thấp | Gần thời gian thực |
| Giá thị trường | API / File | Theo nguồn cung cấp |

- Nguyên tắc chọn ingestion: dùng phương thức đơn giản nhất đáp ứng được độ trễ, độ chính xác và mức tải cho phép trên nguồn.
- Cập nhật mỗi 5 phút không nhất thiết cần Kafka nếu bảng có `UPDATED_AT` đáng tin cậy.

Data Quality theo lớp (Hình 6):

| Lớp | Kiểm tra tham khảo |
|---|---|
| Bronze | Số lượng bản ghi, thời gian cập nhật, batch completeness |
| Silver | Null, duplicate, business constraints |
| Gold | Đối soát chỉ tiêu và logic nghiệp vụ |

Governance tối thiểu (Hình 7):

| Dataset | Owner | Source | Refresh |
|---|---|---|---|
| Daily Trading | Trading / BI | Core | 15 phút |
| Margin Exposure | Risk | Core | 15 phút |
| Branch Revenue | Finance | Core | Hằng ngày |

Nhóm chỉ số Observability (Hình 8):

| Nhóm | Ví dụ |
|---|---|
| Pipeline Health | Success / Failed / Duration |
| Data Freshness | Lần cập nhật thành công gần nhất |
| Data Volume | Số record theo từng batch |
| Data Quality | Số lần kiểm tra thất bại |
| Resource Usage | CPU, RAM, Disk, DB connections |
| Storage Growth | Dung lượng theo ngày/tháng |

Dashboard vận hành mẫu (Hình 9, minh họa):
- Pipelines: 24/25 chạy thành công.
- Freshness: 8 phút (dataset chính).
- Data Quality: 98,5% checks passed.
- Storage: 2,4 TB.
- Pipeline cần chú ý: `margin_exposure_refresh` – Failed – "lần chạy gần nhất thất bại, cần kiểm tra log và dữ liệu đầu vào".

Stack của hai phương án (Hình 10 và 11):

| Thành phần | A – Lightweight | B – Lakehouse |
|---|---|---|
| Data Sources | Oracle, SQL Server, PostgreSQL | — |
| Ingestion | Python / SQL | Python / JDBC / CDC |
| Orchestration | Apache Airflow | Apache Airflow |
| Storage | PostgreSQL | MinIO / S3 (Object Storage) |
| Table Format | — | Apache Iceberg |
| Processing / Query | — | Spark / Trino |
| Transformation | SQL / dbt Core | SQL / Spark / dbt với adapter phù hợp |
| Data Quality | SQL Checks / dbt Tests | SQL / Great Expectations |
| Data Serving | SQL Views / Aggregated Tables | — |
| BI | Power BI / Superset | Power BI / Superset |
| Monitoring | Airflow + Grafana / ELK | Grafana / ELK |
| Version Control | GitLab | — |

Khi nào chọn phương án nào (Hình 12):

| Tiêu chí | Lightweight | Lakehouse |
|---|---|---|
| Dữ liệu vừa phải | Phù hợp | Có thể dư thừa |
| Báo cáo SQL truyền thống | Phù hợp | Phù hợp |
| Lưu lịch sử dữ liệu rất lớn | Cần đánh giá kỹ | Thường thuận lợi hơn |
| Batch transformation nặng | Phụ thuộc DB | Có thể mở rộng compute |
| Đội ngũ vận hành nhỏ | Dễ tiếp cận | Phức tạp hơn |
| Chi phí vận hành ban đầu | Thường thấp hơn | Thường cao hơn |
| Mở rộng nhiều processing engines | Hạn chế hơn | Linh hoạt hơn |

- Không chọn theo một ngưỡng dung lượng cố định như 1 TB hay 10 TB:
  - Một DB vài TB được tối ưu tốt vẫn phục vụ hiệu quả.
  - Một workload nhỏ hơn nhưng cần kết hợp nhiều loại dữ liệu hoặc xử lý phân tán lại có thể hợp Lakehouse.
  - Kiến trúc chọn theo **workload thực tế**.
- "Có bắt buộc Spark và Iceberg?" — **Không.**
  - Có thể bắt đầu bằng PostgreSQL hoặc DW sẵn có, tổ chức Bronze/Silver/Gold dưới dạng schema và bảng.
  - Cân nhắc Object Storage kết hợp Iceberg/Delta Lake khi: dữ liệu tăng, cần lưu lịch sử lớn, nhiều engine cùng khai thác, hoặc cần file-based tables.
  - Iceberg hỗ trợ schema evolution và đổi partition layout mà không phải thiết kế lại bảng. Hình 4 chỉ là logo Apache Iceberg đi kèm trích dẫn nguồn, không phải bảng.

**6. Best practices / nguyên tắc thiết kế**
- Trả lời 6 câu hỏi trước khi thiết kế, để tránh chọn công nghệ quá mức:
  - Dữ liệu nào cần đưa về platform?
  - Cần cập nhật mỗi ngày, mỗi giờ hay mỗi 5 phút?
  - Khối lượng và tốc độ tăng trưởng?
  - Phòng ban nào sử dụng?
  - Ai chịu trách nhiệm về tính chính xác?
  - Hạ tầng và đội ngũ vận hành được đến đâu?
- Mỗi bảng một phương thức ingestion phù hợp. Checkpoint chỉ được cập nhật sau khi ghi thành công.
- Bronze có metadata để truy vết. Dữ liệu lỗi đưa vào quarantine.
- Thiết kế Dependency, Retry, Idempotency và Backfill ngay từ đầu:
  - Gold không được chạy trước khi Silver cần thiết đã sẵn sàng.
  - Retry có kiểm soát với lỗi tạm thời.
  - Chạy lại cùng một khoảng dữ liệu không được nhân đôi kết quả.
- Airflow chỉ điều phối. Task nặng giao cho Database, Spark hoặc worker phù hợp.
- Data Quality đặt đúng chỗ theo từng lớp. Nếu chênh lệch đối soát vượt ngưỡng: cảnh báo và **chưa công bố dataset mới**.
- Mỗi dataset quan trọng cần có người phụ trách nghiệp vụ, mục đích, nguồn và quy tắc tính toán chính. Đây là nền tảng để phát triển Data Contract và Data Product sau này.
- Các báo cáo dùng chung một định nghĩa metric qua Semantic Layer.
- Chỉ đưa thành Data Product những nhóm dữ liệu có người dùng thật và mang lại giá trị.
- Observability tận dụng công cụ sẵn có. Một dashboard nhỏ chỉ cần trả lời: pipeline có chạy, dữ liệu có mới, dữ liệu có đáng tin cậy.
- 5 nguyên tắc giữ từ đầu:
  1. Không làm ảnh hưởng hệ thống nguồn.
  2. Thiết kế để chạy lại và backfill được.
  3. Version control: SQL, DAG, transformation code và cấu hình nằm trong Git, triển khai qua quy trình, không sửa trực tiếp trên Production.
  4. Tách môi trường: ít nhất phải có cách test trước khi đưa lên Production, kể cả khi chưa đủ ngân sách cho 3 môi trường.
  5. Đo lường bằng giá trị nghiệp vụ.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Báo cáo truy vấn thẳng vào DB nghiệp vụ, xuất Excel, hoặc dùng job đồng bộ rời rạc. Cách làm này gây 4 vấn đề:
  - Tải lên Production tăng cao khi chạy SQL tổng hợp trên hàng triệu giao dịch.
  - Logic tính toán phân tán: hai bộ phận có thể dùng hai công thức doanh thu khác nhau.
  - Khó quản lý lịch sử vì nhiều bảng chỉ lưu trạng thái hiện tại.
  - Khó vận hành: thiếu retry, backfill, không theo dõi được dữ liệu đến chậm.
- Triển khai Kafka, Debezium hoặc streaming chỉ vì "Data Platform hiện đại thường có".
- Dùng một phương thức ingestion cho mọi bảng.
- Xóa tùy tiện các dòng không hợp lệ, khiến dữ liệu thiếu hụt mà không có dấu vết.
- Dồn dữ liệu lớn vào bộ nhớ của Airflow.
- Tin vào "SUCCESS, 150,000 records loaded" trong khi tổng giá trị giao dịch thấp hơn nguồn. Nguyên nhân có thể là bỏ sót giao dịch cập nhật muộn, xử lý sai trạng thái hoặc thiếu một khoảng thời gian.
- Chỉ kiểm tra Null/Duplicate.
- Dựng Data Catalog quá lớn ngay từ đầu.
- Biến mọi bảng thành Data Product.
- Mỗi dashboard tự định nghĩa metric. Ví dụ Active Customer: dashboard này tính "có giao dịch trong 30 ngày", dashboard kia tính "có tài khoản đang hoạt động".
- Chọn kiến trúc theo ngưỡng dung lượng.
- Xây toàn bộ platform trước khi có báo cáo đầu tiên: dự án kéo dài mà các phòng ban chưa thấy giá trị.
- Mặc định mỗi giai đoạn có thời lượng cố định.
- Đánh giá platform bằng số pipeline, số dataset hay số TB.

**8. Ví dụ minh họa**
- **Bối cảnh**: doanh nghiệp tài chính/chứng khoán với 5 hệ thống ở Hình 1. Nhu cầu báo cáo:
  - doanh thu giao dịch theo ngày và chi nhánh;
  - số khách hàng mở mới;
  - dư nợ margin và tài sản bảo đảm;
  - giá trị giao dịch theo nhóm khách hàng;
  - dashboard điều hành.
- **Bảng cần đồng bộ**: `CUSTOMER, ACCOUNT, ORDER, TRADE, CASH_TRANSACTION, SECURITIES_BALANCE`.
- **Backfill**: dữ liệu giao dịch ngày 20/10 sai do logic tính toán → chạy lại riêng ngày đó, không phải xóa và tải lại toàn bộ platform. Tác giả dẫn Airflow 3.4.0 Documentation: backfill cho DAG theo lịch, có tùy chọn xử lý lại các lần chạy đã tồn tại và giới hạn số lần chạy đồng thời.
- **DQ SQL** trên `silver.trade`:
  - tìm `trade_id` trùng bằng `GROUP BY ... HAVING COUNT(*) > 1`;
  - đếm bản ghi có `trade_id IS NULL`.
- **Reconciliation**: Source Trading Value = 125,000,000,000 = Gold Trading Value → PASS.
- **Star schema**: `fact_trade, dim_customer, dim_branch, dim_security, dim_date`, cho phép phân tích theo thời gian, khách hàng, chi nhánh và mã chứng khoán.
- **Các KPI cần thống nhất**: Trading Value, Active Customer, Net Revenue, Margin Outstanding.
- **Metric "Total Trading Value"**: định nghĩa `SUM(executed_trade_value)`; grain là từng giao dịch; chỉ tính các lệnh khớp hợp lệ; owner là Trading/Finance.
- **Data Product "Customer Trading Analytics"**:
  - Owner: Trading Department.
  - Datasets: `daily_trading_summary`, `customer_trading_activity`.
  - Refresh: mỗi 15 phút.
  - Consumers: BI Dashboard, Risk Reports, Internal APIs.

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle, SQL Server, PostgreSQL, API/CSV**: nguồn dữ liệu. PostgreSQL còn là storage của phương án A và nơi lưu lịch sử batch cùng kết quả quality check.
- **Python, SQL, JDBC**: ingestion.
- **Kafka, Debezium**: CDC/streaming, chỉ dùng khi thật cần.
- **Apache Airflow**: điều phối batch và micro-batch; dependency, retry, backfill. Không thay thế processing engine.
- **Spark**: transformation nặng. **Trino**: SQL tương tác.
- **Flink, DataHub**: chỉ xuất hiện trong danh sách công cụ của các reference architecture "đầy đủ".
- **MinIO/S3 + Apache Iceberg (hoặc Delta Lake)**: storage và table format cho Lakehouse; kèm Iceberg Catalog.
- **dbt Core / dbt Tests, Great Expectations, SQL checks**: transformation và Data Quality.
- **Grafana, Prometheus, ELK/Elasticsearch**: monitoring và log. **Email/Teams**: cảnh báo.
- **Power BI, Superset**: BI. **GitLab/Git**: version control.

**10. Checklist / câu hỏi thiết kế**

Roadmap 4 giai đoạn:
1. **Foundation & First Data Pipeline**
   - Chọn một bài toán rõ ràng, ví dụ báo cáo giao dịch hằng ngày.
   - Dựng storage, orchestration và ingestion cho vài bảng trọng tâm.
   - Có Bronze/Silver/Gold và một dashboard dùng được.
2. **Quality & Operations**
   - Thêm checkpoint, retry, backfill, đối soát dữ liệu và cảnh báo pipeline.
   - Phân quyền tối thiểu và quy trình xử lý sự cố.
3. **Business Data Products**
   - Mở rộng sang các domain Customer, Finance, Risk.
   - Chuẩn hóa metric, mô hình dữ liệu và trách nhiệm Data Owner.
   - Tái sử dụng dataset giữa các báo cáo.
4. **Scale & Optimization**
   - Chỉ thêm CDC, distributed processing, Lakehouse, metadata automation hay các khả năng nâng cao khi có nhu cầu và số liệu chứng minh.

Thời gian mỗi giai đoạn không cố định. Nó phụ thuộc chất lượng dữ liệu nguồn, độ phức tạp nghiệp vụ, hạ tầng và nhân sự.

5 chỉ số đo giá trị nghiệp vụ:
- Thời gian tạo báo cáo giảm bao nhiêu?
- Bao nhiêu báo cáo đã ngừng truy vấn trực tiếp vào hệ thống nguồn?
- Dữ liệu có được cập nhật đúng thời gian cam kết?
- Bao nhiêu dataset đang thực sự được sử dụng?
- Khi số liệu sai, mất bao lâu để tìm nguyên nhân và xử lý?

**11. Kết luận & key takeaways**
- Qua 16 bài, series đã đi từ khái niệm nền tảng tới một kiến trúc end-to-end tương đối hoàn chỉnh: nguồn → ingestion → Bronze/Silver/Gold → orchestration → quality → Data Products → BI/ứng dụng/AI.
- Điều quan trọng nhất không nằm ở số lượng công nghệ. Platform tốt là platform giải quyết được bài toán dữ liệu với độ phức tạp và chi phí vận hành hợp lý.
- Doanh nghiệp Việt Nam nên bắt đầu bằng hệ "vừa đủ". Khi đã ổn định và có nhu cầu thật mới mở rộng sang CDC, Lakehouse, Data Catalog, Semantic Layer chuyên biệt hoặc Data Mesh.
- Chọn kiến trúc theo workload, không theo dung lượng.
- Có thể xây platform có giá trị thực tế mà không cần đội ngũ lớn hay ngân sách Enterprise.
- Mục tiêu của cả series: hiểu đúng kiến trúc, chọn công nghệ có lý do và xây hệ thống vận hành được.
- Hai trích dẫn:
  - *"đủ đơn giản để triển khai, đủ ổn định để vận hành và đủ linh hoạt để phát triển"*
  - *"Không có một Reference Architecture duy nhất phù hợp với mọi doanh nghiệp."*

**12. Liên kết với các bài khác**
- Tổng hợp gần như toàn bộ các bài trước (danh sách ở phần mở đầu). Nhắc thẳng **Bài 15** ở mục 8 khi bàn về Observability.
- Tự nhận là "bài cuối của phần kiến trúc", và Kết luận viết "qua 16 bài của series".
- Mở đường cho **Bài 17**, nơi kiến trúc này được áp dụng vào công ty chứng khoán. Bài 17 giữ cùng stack Lightweight (PostgreSQL + Airflow + Python + BI) và cùng tư duy roadmap theo giai đoạn.

---

## Bài 17: Securities Data Platform – Từ Reference Architecture đến triển khai thực tế trong doanh nghiệp chứng khoán
*Subtitle: "Thiết kế nền tảng dữ liệu phục vụ báo cáo, phân tích và khai thác dữ liệu tại công ty chứng khoán Việt Nam." · Đăng 2026-10-17 · 12 hình/bảng (Hình 4 và Hình 5 là cùng một sơ đồ, bị lặp)*

Mục lục (H2): 1. Bài toán dữ liệu trong doanh nghiệp chứng khoán | 2. Bắt đầu từ Business Requirements, không phải Technology Stack | 3. Phân loại Data Sources và lựa chọn chiến lược Ingestion | 4. Thiết kế Securities Data Platform Reference Architecture | 5. Tổ chức dữ liệu theo Bronze, Silver và Gold | 6. Xây dựng Analytical Data Model cho nghiệp vụ chứng khoán | 7. Thiết kế End-to-End Pipeline: Từ Core Securities đến Margin Dashboard | 8. Data Quality, Reconciliation và Governance | 9. Orchestration, Monitoring và vận hành thực tế | 10. Lộ trình triển khai thực tế: Từ MVP đến Production | Kết luận – Một Data Platform tốt không nhất thiết phải phức tạp

**1. Bối cảnh & vấn đề mở đầu**
- Bài 16 đã có kiến trúc tổng thể. Câu hỏi tiếp theo: áp dụng vào một doanh nghiệp thật — công ty chứng khoán Việt Nam — thì thiết kế thế nào?
- Đây là lĩnh vực đặc thù: dữ liệu gắn trực tiếp với tài sản khách hàng, giao dịch, dư nợ margin, quản trị rủi ro và tuân thủ.
- Công ty vận hành nhiều hệ thống độc lập (Core Securities, Trading System, CRM, Market Data, Accounting, các hệ thống nội bộ), mỗi hệ thống có database, mô hình dữ liệu và cách vận hành riêng.
- Mỗi bên lại có nhu cầu riêng: kinh doanh phân tích khách hàng, rủi ro theo dõi margin, lãnh đạo cần báo cáo tổng hợp, vận hành cần số liệu nhất quán.
- Câu hỏi đặt ra: xây được platform đủ mạnh mà vẫn hợp nguồn lực và ngân sách doanh nghiệp Việt Nam không?
- Cách tiếp cận của bài: thực tế, từng bước, "không cố gắng đưa mọi công nghệ vào cùng một kiến trúc".

**2. Luận điểm cốt lõi**
- Securities Data Platform phải:
  - xuất phát từ nghiệp vụ (Business-Driven);
  - triển khai tăng dần, không Big Bang;
  - đặt độ tin cậy của dữ liệu lên trên độ phức tạp công nghệ — tức dữ liệu đúng, đối soát được, truy vết được, phục hồi được và đúng SLA.
- Platform tiếp nhận, chuẩn hóa, tích hợp và cung cấp dữ liệu phân tích. Nó **không thay thế hệ thống nghiệp vụ** và không nằm trên đường xử lý giao dịch.

**3. Khái niệm chính**
- **Vai trò của Data Platform**: không can thiệp vào transaction của Core Securities hay Trading System.
- **Operational Data và Analytical Data**:
  - Kiểm tra sức mua, đặt lệnh, phong tỏa tiền, kiểm soát tỷ lệ margin trước giao dịch phải do hệ thống nghiệp vụ độ trễ rất thấp xử lý.
  - Platform phục vụ phân tích, giám sát, đối soát, báo cáo. Nó không nên nằm trên đường giao dịch quan trọng "nếu chưa có một thiết kế chuyên biệt".
- **Định nghĩa KPI**: *Active Customer* có thể hiểu theo 3 cách — đăng nhập trong 30 ngày; có ít nhất một lệnh đặt trong 30 ngày; có ít nhất một giao dịch khớp trong 30 ngày. Phải thống nhất trước khi xây pipeline.
- **Master Data** (`CUSTOMER, ACCOUNT, BRANCH, BROKER, SECURITIES`):
  - Dung lượng không lớn, ít thay đổi, nhưng cần đồng bộ khá thường xuyên và phải giữ quan hệ giữa các đối tượng.
  - Dùng Incremental nếu nguồn có cột thời gian cập nhật đáng tin cậy.
- **Transaction Data** (`ORDER, ORDER_EXECUTION, TRADING_TRANSACTION, CASH_TRANSACTION, SECURITIES_TRANSACTION`):
  - Tăng liên tục, có cập nhật/hủy/sửa, cần lịch sử đầy đủ, không được mất hay nhân đôi.
  - Dùng Incremental hoặc CDC.
- **Snapshot Data** (`CUSTOMER_CASH_BALANCE, CUSTOMER_SECURITIES_BALANCE, MARGIN_OUTSTANDING, CUSTOMER_PORTFOLIO`): trạng thái tại một thời điểm, nên phải chụp snapshot theo ngày hoặc theo chu kỳ phù hợp.
- **`TXDATE` và `UPDATED_AT`**: `TXDATE` thường là ngày nghiệp vụ, không phải thời điểm bản ghi được cập nhật.
- **Grain của fact table**: không rõ grain thì rất dễ tính trùng khi join hoặc aggregate.
- **Cùng mốc thời gian**: các chỉ tiêu rủi ro phải dùng chung một thời điểm dữ liệu.
- **6 nguyên tắc pipeline**:
  - Idempotency: chạy lại một batch không tạo thêm dữ liệu trùng.
  - Checkpoint: biết chính xác đã xử lý tới đâu.
  - Retry: tự động thử lại với lỗi tạm thời.
  - Backfill: xử lý lại được dữ liệu lịch sử.
  - Atomic Publish: người dùng không nhìn thấy batch Gold đang ghi dở.
  - Freshness Monitoring: phát hiện dữ liệu không cập nhật đúng SLA.
- **Metadata-Driven ingestion**: một cơ chế cấu hình chung thay vì viết riêng chương trình cho từng bảng.

**4. Kiến trúc, pattern & quy trình**
- **3 yêu cầu của kiến trúc**: tiếp nhận dữ liệu từ nhiều hệ thống; lưu và xử lý dữ liệu lịch sử; cung cấp dữ liệu đáng tin cậy cho báo cáo và phân tích.
- **Sơ đồ (Hình 4/5):**
  - `Enterprise Data Sources (Core Securities · Trading/OMS · CRM · Market Data · Accounting · Internal Systems)`
  - `→ Data Ingestion (Batch · Incremental · CDC · API)`
  - `→ Data Lakehouse (Bronze Raw → Silver Cleansed → Gold Business; xử lý bằng SQL/Python, Spark khi cần)`
  - `→ Data Consumption (BI/Dashboard · Reporting/API · AI/Analytics)`
  - Shared Platform Services: Orchestration · Data Quality · Metadata · Security · Monitoring.
- **Mỗi khối không nhất thiết là một phần mềm riêng.**
  - Bronze/Silver/Gold có thể cùng nằm trên một Object Storage, hoặc ở giai đoạn đầu nằm trong một Analytical Database.
  - Không phải pipeline nào cũng cần Spark; với dữ liệu vừa phải, SQL/Python là đủ.
  - Vài chục bảng và vài báo cáo: Airflow + Python + PostgreSQL + BI đã mang lại giá trị đáng kể.
  - Khi dữ liệu tăng, mở rộng dần sang Object Storage, Lakehouse Table Format và Distributed Processing.
- **Bronze:**
  - Cấu trúc thư mục: `bronze/core/{customers, accounts, cash_transactions, securities_balances}`, `bronze/trading/{orders, executions}`, `bronze/market/{daily_prices}`.
  - Metadata: `source_system, source_table, ingestion_timestamp, batch_id, source_operation`. `source_operation` chỉ có nghĩa khi nguồn cung cấp loại thay đổi, ví dụ qua CDC.
  - Nguyên tắc: Bronze phải cho phép truy xuất lại dữ liệu đã nhận, không chỉ giữ trạng thái mới nhất — để tái xử lý, đối soát và điều tra lỗi.
- **Silver:**
  - Core dùng `CUSTID, ACCTNO, CODEID, TXDATE`; CRM dùng `CUSTOMER_ID, ACCOUNT_ID, CUSTOMER_CODE`. Cả hai được chuẩn hóa về `customer_id, account_id, security_id, transaction_date`.
  - Không thể chỉ đổi tên cột. Phải hiểu quan hệ nghiệp vụ: một khách hàng có nhiều tài khoản; tài khoản có tiểu khoản cho các nghiệp vụ khác nhau; mã chứng khoán có thể được định danh khác nhau ở mỗi nguồn.
  - Việc của Silver: chuẩn hóa data types; mapping business keys; khử trùng lặp do ingestion; xử lý bản ghi cập nhật/hủy; chuẩn hóa ngày nghiệp vụ và timestamp; kiểm tra quan hệ giữa các bảng.
- **Gold:**
  - Không phải "bản sao Silver với ít cột hơn" mà là các Business Data Products.
  - Gồm: `gold/{customer_360, daily_trading_summary, brokerage_performance, margin_exposure, customer_portfolio, financial_summary}`.
- **Mô hình phân tích:**
  - **Customer 360**: `Customer → Accounts | Trading History | Cash Balance | Securities Portfolio | Margin Outstanding | Brokerage Information`.
    - Phân tích được tổng tài sản, tần suất và giá trị giao dịch, dư nợ margin, doanh thu từ khách hàng, thay đổi hành vi giao dịch.
    - Có thể cấp dữ liệu cho CRM Analytics và chăm sóc khách hàng.
  - **Trading Analytics**:
    - Dimensions: `dim_customer, dim_account, dim_security, dim_broker, dim_branch, dim_date`.
    - Facts: `fact_trade_execution` (grain: một lần khớp lệnh), `fact_daily_trading` (tổng hợp theo ngày × tài khoản × mã CK), `fact_trading_fee`.
    - SQL mẫu: `SUM(trading_value)`, `SUM(trading_fee)` từ `gold.fact_daily_trading`, nhóm theo `trade_date, branch_id`.
    - Dashboard: giá trị giao dịch theo ngày, doanh thu môi giới, hiệu suất chi nhánh, tỷ lệ khách hàng hoạt động.
  - **Margin Analytics**: `Margin Loans + Customer Collateral + Securities Prices + Risk Parameters → Margin Exposure`.
    - Phân tích dư nợ theo khách hàng, theo mã, mức độ tập trung, biến động tài sản bảo đảm, phân bố khách hàng theo nhóm rủi ro.
    - Tỷ lệ rủi ro và giá trị tài sản bảo đảm phải theo định nghĩa nghiệp vụ đã phê duyệt, không tự suy ra từ vài trường dữ liệu.
- **Pipeline Margin end-to-end (Hình 8):**
  1. Extract (Margin · Collateral · Market Price): lấy bản ghi thay đổi hoặc snapshot.
  2. Bronze Ingestion: lưu dữ liệu nguồn và metadata batch; xác nhận ghi thành công rồi mới cập nhật checkpoint.
  3. Silver Transformation: chuẩn hóa, deduplicate, mapping mã.
  4. Data Quality & Reconciliation: kiểm tra tổng dư nợ, dữ liệu thiếu, mốc thời gian.
  5. Gold Margin Exposure: tính theo customer, security và thời điểm snapshot; dữ liệu đã tổng hợp và xác nhận.
  6. Margin Risk Dashboard: báo cáo, phân tích, cảnh báo; chỉ publish sau khi pipeline hoàn tất.
- **DAG Airflow `margin_exposure_pipeline`**: `extract_margin + extract_collateral + extract_market_price → transform_silver → validate_data → build_gold → publish_dataset`.
- **Đối soát xuyên tầng**: `Source Trading System (10,000 Executions) → Bronze (10,000) → Silver (10,000 Valid) → Gold (Trading Value = X) → Business Report`.
- **Cấu hình ingestion metadata-driven** (minh họa): source `core_securities`, table `trading_transactions`, strategy `incremental`, watermark_column `updated_at`, schedule `"*/5 * * * *"`, target `bronze.trading_transactions`.

**5. Framework ra quyết định & so sánh**

Hệ thống nguồn (Hình 1):

| Hệ thống | Dữ liệu chính | Đặc điểm |
|---|---|---|
| Core Securities | Khách hàng, tài khoản, số dư, dư nợ | Oracle, Tibero hoặc RDBMS khác |
| Trading System | Lệnh đặt, lệnh khớp, lịch sử giao dịch | Khối lượng giao dịch lớn |
| CRM | Khách hàng, nhân viên môi giới, chăm sóc khách hàng | Dữ liệu thường xuyên thay đổi |
| Market Data | Giá chứng khoán, chỉ số, thanh khoản | Thay đổi liên tục trong phiên |
| Accounting | Bút toán, doanh thu, chi phí | Yêu cầu đối soát chính xác |
| Internal Systems | Dữ liệu quản trị và vận hành | Có thể dùng nhiều loại database |

Use case và độ trễ mục tiêu (Hình 2; chỉ là ví dụ yêu cầu thiết kế, cần thống nhất với từng bộ phận):

| Use Case | Dữ liệu cần thiết | Độ trễ mục tiêu |
|---|---|---|
| Daily Trading Report | Lệnh khớp, giao dịch | Cuối ngày |
| Customer 360 | CRM, tài khoản, giao dịch, tài sản | 15–60 phút |
| Margin Exposure | Dư nợ, tài sản bảo đảm, giá thị trường | 5–10 phút |
| Brokerage Performance | Giao dịch, phí, nhân viên môi giới | 15–60 phút |
| Customer Portfolio | Số dư chứng khoán, tiền, giá | 5–15 phút |
| Financial Reporting | Accounting, Core Securities | Theo kỳ kế toán |

Strategy Matrix (Hình 3):

| Data Source | Strategy | Tần suất tham khảo |
|---|---|---|
| Customer Master | Incremental | 15 phút |
| Account Master | Incremental | 15 phút |
| Trading Transactions | Incremental / CDC | 5 phút |
| Cash Transactions | Incremental / CDC | 5–10 phút |
| Securities Balance | Snapshot | 10–15 phút hoặc EOD |
| Margin Outstanding | Snapshot | 5–10 phút |
| Market Data | API / Streaming | Theo yêu cầu |
| Accounting | Batch | EOD |

Technology stack tham khảo (Hình 6; mô hình self-hosted/hybrid; là danh sách lựa chọn, không bắt buộc):

| Thành phần | Công nghệ có thể dùng |
|---|---|
| Ingestion | Python, JDBC, Debezium khi cần CDC |
| Orchestration | Apache Airflow |
| Storage | S3-compatible Object Storage / MinIO |
| Table Format | Apache Iceberg hoặc Delta Lake khi phù hợp |
| Processing | SQL, Python, Spark |
| Analytical Database | PostgreSQL hoặc ClickHouse tùy workload |
| BI | Power BI, Metabase, Superset |
| Monitoring | Prometheus, Grafana, ELK |

Bảng Gold `daily_trading_summary` (Hình 7, dữ liệu minh họa):

| trade_date | branch_id | broker_id | trading_value | trading_fee |
|---|---|---|---|---|
| 2026-10-20 | HN01 | BR001 | 12,500,000,000 | 18,750,000 |
| 2026-10-20 | HCM01 | BR002 | 8,200,000,000 | 12,300,000 |

Data Quality Rules (Hình 9):

| Loại kiểm tra | Ví dụ |
|---|---|
| Completeness | Không thiếu Customer ID / Account ID bắt buộc |
| Uniqueness | Execution ID không trùng, trừ các trường hợp hợp lệ theo mô hình |
| Referential Integrity | Account phải liên kết với Customer hợp lệ |
| Validity | Ngày giao dịch và trạng thái nằm trong tập giá trị cho phép |
| Freshness | Dữ liệu không vượt quá độ trễ cho phép |
| Reconciliation | Số liệu tổng hợp khớp với nguồn theo quy tắc đối soát |

Governance (Hình 10):

| Dataset | Business Owner | Refresh SLA |
|---|---|---|
| Daily Trading | Trading Operations | EOD |
| Customer 360 | Business / CRM | 30 phút |
| Margin Exposure | Risk Management | 10 phút |
| Financial Summary | Finance | EOD |

Monitoring metrics (Hình 11):

| Metric | Ý nghĩa |
|---|---|
| Pipeline Success Rate | Tỷ lệ pipeline chạy thành công |
| Pipeline Duration | Thời gian hoàn thành |
| Data Freshness | Độ trễ dữ liệu so với SLA |
| Records Processed | Số bản ghi đã xử lý |
| Data Quality Failures | Số lần vi phạm quy tắc chất lượng |
| Reconciliation Difference | Chênh lệch số liệu đối soát |
| Storage Growth | Tốc độ tăng dung lượng |
| Processing Cost | Chi phí xử lý dữ liệu |

Lộ trình (Hình 12):

| | MVP | Expansion | Production |
|---|---|---|---|
| Mục tiêu | Chứng minh giá trị | Dùng chung nhiều nghiệp vụ | Vận hành bền vững |
| Data Sources | 1–2 | 3–5 | Mở rộng theo nhu cầu |
| Use Cases | Trading Analytics | Customer, Margin, Portfolio | Enterprise Analytics |
| Processing | SQL, Python | SQL, Python, Spark nếu cần | Tối ưu theo workload |
| Governance | Cơ bản | Chuẩn hóa | Theo chính sách toàn doanh nghiệp |
| Monitoring | Pipeline & Quality | Freshness, SLA, Cost | Observability toàn diện |

Các quy tắc ra quyết định:
- **Không phải dữ liệu nào cũng cần real-time.**
  - Daily Trading Report chỉ cần xong sau khi dữ liệu cuối ngày đã đối soát.
  - Customer 360 chấp nhận trễ khoảng 15 phút. [Ghi chú] Phần văn bản ghi 15 phút, còn Hình 2 ghi 15–60 phút.
  - Margin Exposure trong phiên cần nhanh hơn.
  - Đưa toàn bộ vào streaming làm tăng đáng kể chi phí triển khai và vận hành mà không tương xứng giá trị.
- **Tần suất ingestion** chọn theo SLA, khả năng chịu tải của DB nguồn và mức độ quan trọng của dữ liệu.
- **Bảo vệ Core trong giờ giao dịch**: không chạy Full Load liên tục. Với nguồn lớn hoặc nhạy cảm, dùng read replica, database báo cáo, CDC hoặc cơ chế trích xuất mà nguồn hỗ trợ.
- **Trước khi chốt Incremental**, phải kiểm tra cách nguồn xử lý sửa, hủy, xóa và giao dịch ghi nhận muộn.
- **Khi các nguồn lệch nhau** (ví dụ Margin Loan đã có dữ liệu 10:10 nhưng Market Price mới tới 10:00): cần quy tắc quyết định công bố bộ dữ liệu này hay giữ phiên bản đã xác nhận trước đó.
- **Số bản ghi giữa các tầng không nhất thiết bằng nhau** khi Silver khử trùng hoặc Gold tổng hợp. Khi đó phải đối soát theo quy tắc biến đổi. Với dư nợ, tài sản, tiền còn phải xét ngày nghiệp vụ, trạng thái giao dịch và thời điểm chốt số liệu.
- **Workload streaming liên tục** cần luồng xử lý riêng, không ép vào DAG chạy theo lịch.
- **Spark, Iceberg, Kafka, Distributed Query Engine** chỉ cân nhắc ở giai đoạn Production, khi khối lượng và nhu cầu thật sự đòi hỏi.

**6. Best practices / nguyên tắc thiết kế**
- Bắt đầu từ business use case và thống nhất độ trễ với từng bộ phận. Định nghĩa KPI trước khi xây pipeline.
- Phân loại nguồn thành Master, Transaction, Snapshot. Không đồng bộ toàn bộ hàng nghìn bảng.
- Với dữ liệu số dư, phải thiết kế snapshot để giữ lịch sử.
- Bronze phải truy xuất lại được dữ liệu đã nhận.
- Silver phải hiểu quan hệ nghiệp vụ, không chỉ đổi tên cột.
- Gold là Business Data Product dùng chung định nghĩa KPI, để giảm tình trạng mỗi phòng ban tự viết SQL riêng.
- Khai báo rõ grain cho mọi fact table.
- Chỉ tiêu rủi ro dùng cùng một mốc thời gian và theo định nghĩa nghiệp vụ đã phê duyệt.
- Áp dụng đủ 6 nguyên tắc pipeline. Chỉ cập nhật checkpoint sau khi đã xác nhận ghi thành công.
- Ở mỗi tầng, đối soát số lượng bản ghi, tổng giá trị và các business key quan trọng.
- Governance bắt đầu bằng 8 trường metadata (xem mục 10).
- Với dữ liệu nhạy cảm, xác định rõ quyền truy cập, masking, encryption, audit logging và thời hạn lưu trữ.
  - Phải rà soát theo quy định hiện hành và yêu cầu riêng của doanh nghiệp, không dùng một cấu hình chung cho mọi loại dữ liệu.
  - Tác giả nêu Ủy ban Chứng khoán Nhà nước đã nhấn mạnh việc tăng cường giám sát, đánh giá và bảo đảm an toàn hệ thống CNTT phục vụ giao dịch chứng khoán.
- Monitoring phải nhìn trạng thái dữ liệu, không chỉ trạng thái chương trình.
- Phân định rõ trách nhiệm giữa Data Engineering/IT và Business/Data Owner, kể cả khi đội nhỏ và một người kiêm nhiều vai.
- Tái sử dụng hạ tầng. Dùng ingestion metadata-driven khi số bảng tăng từ vài chục lên vài trăm.

**7. Anti-patterns, sai lầm thường gặp & rủi ro**
- Chọn công nghệ quá sớm: mải nghiên cứu Kafka, Spark, Flink, Iceberg, Trino, Kubernetes khi chưa rõ yêu cầu.
- Đưa mọi thứ lên real-time hoặc streaming.
- Đặt Data Platform trên đường xử lý giao dịch quan trọng mà không có thiết kế chuyên biệt.
- Mỗi phòng ban một định nghĩa KPI.
- Chỉ đồng bộ trạng thái số dư mới nhất, nên không trả lời được câu hỏi về lịch sử tài sản.
- Chạy Full Load liên tục trên Core trong giờ giao dịch.
- Tin `UPDATED_AT` hoặc `TXDATE` một cách mù quáng.
- Silver chỉ là đổi tên cột; Gold chỉ là bản sao Silver.
- Grain không rõ ràng, dẫn tới tính trùng.
- Trộn nhiều mốc thời gian, ví dụ dư nợ lúc 10:00 nhưng giá lúc 10:15.
- Tự suy diễn tỷ lệ rủi ro từ vài trường dữ liệu.
- Mặc định dữ liệu mới hơn là dữ liệu tốt hơn.
- Chỉ giám sát trạng thái job.
- Vận hành bằng Cron Job rồi kiểm tra thủ công khi có lỗi.
- Dùng Airflow làm engine xử lý dữ liệu, hoặc ép workload streaming vào DAG theo lịch.
- Thiếu Business Owner, khiến đội kỹ thuật phải tự định nghĩa KPI nghiệp vụ mà không đủ cơ sở quyết định.
- Xây Enterprise Data Platform kiểu Big Bang.
- Coi số công nghệ đã triển khai là thước đo trưởng thành.

**8. Ví dụ minh họa**
- **Câu hỏi của từng bộ phận:**
  - Kinh doanh: khách hàng nào giao dịch tích cực; doanh thu môi giới theo nhân viên; khách hàng nào có dấu hiệu ngừng giao dịch.
  - Rủi ro: tổng dư nợ margin; dư nợ tập trung vào mã nào; khách hàng nào có tỷ lệ rủi ro cao.
  - Lãnh đạo: tổng giá trị giao dịch trong ngày; số khách hàng hoạt động; tăng trưởng tài sản khách hàng theo tháng; hiệu quả theo chi nhánh.
- **Hiện trạng**: một báo cáo có thể phải lấy dữ liệu từ 3–4 database rồi xử lý bằng SQL, Excel hoặc app nội bộ. Khi báo cáo tăng lên thì xuất hiện:
  - KPI lệch nhau giữa các phòng ban;
  - truy vấn báo cáo làm chậm DB nghiệp vụ;
  - lịch sử khó truy xuất hoặc không đầy đủ;
  - khó tìm nguyên nhân khi hai báo cáo lệch số;
  - mỗi báo cáo có một quy trình lấy dữ liệu riêng.
- **Snapshot**: khách hàng có 500 triệu hôm nay, 700 triệu ngày mai. Nếu chỉ giữ trạng thái mới nhất thì không trả lời được "tài sản thay đổi thế nào trong 6 tháng qua?".
- **Pipeline Margin**: bộ phận rủi ro cần dữ liệu làm mới mỗi 5–10 phút. Nguồn gồm Core Securities (Margin Loans, Customer Collateral), Market Data (Securities Prices) và CRM/Core (Customer Information).
- **Lệch đối soát**: pipeline SUCCESS, nhưng Source Margin Outstanding là 1,250,000,000,000 VND còn Gold là 1,245,000,000,000 VND → **lệch 5 tỷ đồng**. Nếu chỉ giám sát trạng thái job thì không phát hiện được.
- **STALE**: lần chạy thành công cuối lúc 10:00, hiện tại 10:25, SLA 10 phút → dữ liệu STALE dù lần chạy cuối vẫn thành công.
- **MVP "Daily Trading Analytics" (4–8 tuần):**
  - Kết nối Core/Trading DB, đồng bộ dữ liệu giao dịch, dựng Bronze/Silver/Gold.
  - Tạo bảng tổng hợp giao dịch theo ngày và dashboard; thiết lập DQ và monitoring cơ bản.
  - Stack: `Source DB → Python Ingestion → PostgreSQL → SQL Transformation → BI Dashboard`, Airflow điều phối.
  - Chưa cần Kafka, Spark hay Kubernetes.
- **Expansion (2–4 tháng tiếp theo):**
  - Mở rộng sang Customer 360, Margin Exposure, Brokerage Performance, Customer Portfolio.
  - Cân nhắc thêm: Object Storage cho lịch sử; CDC cho nguồn thật sự cần độ trễ thấp; Metadata Catalog; Data Quality Framework; Centralized Monitoring; Data Access Control.
  - Cấu hình YAML ở mục 4 chỉ là minh họa: việc xử lý xóa bản ghi, cập nhật muộn, checkpoint và lịch chạy trong phiên phải thiết kế theo khả năng thực tế của nguồn.

**9. Công nghệ/công cụ được nhắc tới**
- **Oracle, Tibero, RDBMS khác**: database của Core Securities.
- **Python, JDBC**: ingestion. **Debezium**: CDC khi cần.
- **Apache Airflow**: điều phối — workflow bằng Python, dependencies, scheduling, retry, backfill, theo dõi trạng thái. Không thay thế Spark, SQL hay Python trong khâu xử lý.
- **S3-compatible Object Storage / MinIO**: lưu trữ. **Apache Iceberg / Delta Lake**: table format khi phù hợp.
- **SQL, Python, Spark**: xử lý; Spark chỉ khi cần.
- **PostgreSQL / ClickHouse**: Analytical Database tùy workload. PostgreSQL là lõi của MVP.
- **Power BI, Metabase, Superset**: BI.
- **Prometheus, Grafana, ELK**: monitoring.
- **Kafka, Flink, Trino, Kubernetes**: được nêu như những công nghệ dễ bị "nghiên cứu quá sớm". Kafka, Spark, Iceberg và Distributed Query Engine chỉ cân nhắc ở giai đoạn Production.
- **Cron Job**: không đủ khi số pipeline tăng.
- **CI/CD**: dùng cho data pipeline ở giai đoạn Production.

**10. Checklist / câu hỏi thiết kế**
- **Trình tự thiết kế:**
  1. Liệt kê use case cùng dữ liệu cần thiết và độ trễ mục tiêu.
  2. Thống nhất KPI.
  3. Phân loại nguồn và lập Strategy Matrix.
  4. Thiết kế Bronze/Silver/Gold.
  5. Xây mô hình phân tích (Customer 360, Trading, Margin) với grain rõ ràng.
  6. Xây pipeline 6 bước đáp ứng 6 nguyên tắc.
  7. Thiết lập DQ, Reconciliation và Governance.
  8. Thiết lập Orchestration và Monitoring.
- **8 trường metadata governance**: Dataset Name, Business Owner, Technical Owner, Source System, Refresh Frequency, Business Definition, Data Classification, Retention Policy.
- **Phân vai:**
  - Data Engineering/IT: xây và vận hành pipeline; quản lý storage, processing, infrastructure; xử lý lỗi kỹ thuật; giám sát performance và capacity.
  - Business/Data Owner: định nghĩa dữ liệu; phê duyệt KPI; kiểm tra độ chính xác nghiệp vụ; xác nhận yêu cầu và chất lượng đầu ra.
- **Tiêu chí nghiệm thu MVP:**
  - đối soát khớp với hệ thống nguồn;
  - chạy lại batch an toàn;
  - có cảnh báo khi pipeline lỗi;
  - người dùng nghiệp vụ xác nhận báo cáo đáp ứng yêu cầu.
- **Ưu tiên ở giai đoạn Production:**
  - tối ưu hiệu năng và chi phí;
  - kiểm soát truy cập theo vai trò;
  - backup, restore, disaster recovery;
  - quản lý Data Lineage và thay đổi schema;
  - CI/CD cho pipeline;
  - SLA và Incident Management;
  - kiểm thử khôi phục và đối soát định kỳ.
- Các mốc thời gian chỉ là định hướng lập kế hoạch, không phải cam kết. Tích hợp Core, kiểm thử đối soát và phê duyệt quyền truy cập dữ liệu có thể chiếm phần lớn thời gian dự án.

**11. Kết luận & key takeaways**
- Mọi thành phần của 16 bài trước đều có chỗ trong kiến trúc thực tế:
  - Ingestion: tiếp nhận dữ liệu.
  - Storage và Medallion: tổ chức theo mức độ xử lý.
  - Analytical Data Modeling: biến dữ liệu kỹ thuật thành ý nghĩa nghiệp vụ.
  - DQ và Reconciliation: độ tin cậy.
  - Orchestration và Observability: vận hành ổn định.
  - Governance: dữ liệu, quyền truy cập, trách nhiệm sở hữu.
  - Nhưng không cần triển khai tất cả từ ngày đầu.
- Ba nguyên tắc:
  1. Business-Driven thay vì Technology-Driven.
  2. Incremental Architecture thay vì Big Bang.
  3. Data Reliability quan trọng hơn Technology Complexity.
- Trong chứng khoán, dữ liệu gắn trực tiếp với tiền, tài sản và giao dịch của khách hàng, nên độ tin cậy phải đặt lên hàng đầu: "dữ liệu đúng quan trọng không kém dữ liệu nhanh".
- Một hệ PostgreSQL + Airflow + Python được tổ chức tốt, chính xác, có giám sát và đạt SLA có thể giá trị hơn một Lakehouse phức tạp khó vận hành.
- Điểm khởi đầu tốt nhất có thể chỉ là một pipeline đủ tốt cho một báo cáo đúng, đúng thời điểm và kiểm chứng được. Phần còn lại sẽ phát triển tự nhiên từ đó.
- Hai trích dẫn:
  - *"Modern Data Platform không phải là tập hợp của Kafka, Spark, Airflow, Iceberg hay bất kỳ công nghệ cụ thể nào."*
  - *"Không nên mặc định dữ liệu mới hơn luôn đồng nghĩa với dữ liệu tốt hơn."*

**12. Liên kết với các bài khác**
- Xây trực tiếp trên **Bài 16**: mở đầu bằng kiến trúc tổng thể của bài trước, và Kết luận điểm lại "16 bài trước". Đây là bài khép lại series, đóng vai case study áp dụng.
- Áp dụng gần như toàn bộ series:
  - Ingestion: Incremental, CDC, Snapshot, watermark, checkpoint.
  - Medallion.
  - Data Modeling: fact/dim, grain.
  - Semantic Layer/KPI: ví dụ Active Customer.
  - Data Products: Gold là Business Data Products.
  - Data Quality và Data Contract: rules, reconciliation.
  - Governance.
  - Orchestration: Airflow, backfill.
  - Metadata-Driven ingestion.
  - Observability (Bài 15): freshness so với SLA, ví dụ STALE.
- So với Bài 16: cùng roadmap theo giai đoạn (Bài 16 có 4 giai đoạn không gắn thời gian; Bài 17 có 3 giai đoạn MVP → Expansion → Production kèm mốc thời gian tham khảo) và cùng stack Lightweight.

---

## Chủ đề xuyên suốt (từ các bài được giao)
- **Bắt đầu nhỏ, mở rộng khi có nhu cầu và số liệu chứng minh.** Số lượng công nghệ không phải thước đo trưởng thành. Cả ba bài đều đưa ra lộ trình theo giai đoạn: Observability 3 giai đoạn (Bài 15), roadmap 4 giai đoạn và lựa chọn Lightweight hay Lakehouse (Bài 16), MVP → Expansion → Production (Bài 17).
- **Nghiệp vụ đi trước công nghệ.** Xác định use case, độ trễ/SLA từng dataset, định nghĩa KPI (Active Customer) và Business/Data Owner trước khi chọn stack. Chọn kiến trúc theo workload, không theo dung lượng hay xu hướng.
- **"SUCCESS" không có nghĩa là dữ liệu đúng hay mới.** Phải giám sát trạng thái dữ liệu: freshness so với SLA, volume so với baseline, reconciliation với nguồn. Ví dụ lặp lại ở cả 3 bài:
  - `customer_daily_sync` thành công nhưng không có dữ liệu mới;
  - 150,000 records được load nhưng giá trị giao dịch vẫn thiếu;
  - dư nợ margin lệch 5 tỷ;
  - dataset STALE dù lần chạy cuối thành công.
- **Chạy lại được và khôi phục được.** Idempotency; checkpoint/watermark chỉ cập nhật sau khi ghi thành công; retry; backfill; atomic publish hoặc giữ phiên bản đã xác nhận; quarantine; runbook xử lý sự cố.
- **Giải pháp nhẹ và công cụ sẵn có trước.** Bảng metadata cho lineage và governance; SQL view làm Semantic Layer; Airflow + PostgreSQL + Grafana/ELK; ngưỡng cảnh báo đơn giản trước ML/AI. Airflow chỉ điều phối, không xử lý dữ liệu nặng.
- **Bảo vệ hệ thống nguồn và tôn trọng đặc thù chứng khoán.** Kiểm soát tải trên Production DB, không Full Load trong giờ giao dịch, dùng Trading Calendar, phân biệt ngày nghiệp vụ với timestamp, dùng cùng một mốc thời gian cho chỉ tiêu rủi ro, và để platform phân tích tách khỏi đường xử lý giao dịch.


---

