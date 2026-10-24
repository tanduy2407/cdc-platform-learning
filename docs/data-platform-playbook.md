# Design Checklist Playbook — Modern Data Platform

## How to use

1. Fill in **Part A – Scorecard** to get an overall view of where the platform stands.
2. Walk through **Part B – 18 components** one by one. Each component has:
   - **Decisions to make**: questions that must have a clear answer (record the answer + rationale).
   - **Must have**: a checklist; each line is tagged with how necessary it is:
     - `[MVP]` required from the very first version
     - `[EXP]` needed when expanding (more sources, more domains, more consumers)
     - `[PROD]` needed for production operations at scale / high requirements
   - **Red flags**: signs the design is heading in the wrong direction.
3. Use **Part C** (quick decision tables) when choosing between options.
4. Before go-live, run **Part D – Go-live gate**. Templates are in **Part E**.

> Core principles: business before technology · decide per table/dataset · the simplest solution that meets the requirement · "SUCCESS" ≠ correct data · design for failure from day one · evolve in stages, no Big Bang.

---

## Part A — Overall scorecard

Rate each component: ⬜ not started · 🟨 partial · 🟩 meets what the current stage needs · N/A not needed yet.

| # | Component | Status | Notes / gaps |
|---|---|---|---|
| 1 | Business requirements & KPIs | | |
| 2 | Source systems | | |
| 3 | Ingestion | | |
| 4 | CDC *(if used)* | | |
| 5 | Storage | | |
| 6 | Medallion (Bronze/Silver/Gold) | | |
| 7 | Orchestration | | |
| 8 | Data Quality | | |
| 9 | Data Contract & Schema evolution | | |
| 10 | Analytical Data Model | | |
| 11 | Semantic Layer & Metrics | | |
| 12 | Data Product | | |
| 13 | Governance (catalog, lineage, ownership) | | |
| 14 | Security & Access | | |
| 15 | Recovery (idempotency, replay, backfill) | | |
| 16 | Observability & Operations | | |
| 17 | Performance & Cost | | |
| 18 | Delivery (Git, CI/CD, environments) & Organization | | |

---

## Part B — Checklist per component

### 1. Business requirements & KPIs

**Decisions to make**
- Which business problem does the platform solve? What is the first (MVP) use case?
- What data does each use case need, and what is the **target latency** (agreed with each department)?
- How are the key KPIs defined? (e.g. *Active Customer* = logged in / placed an order / had a matched trade in the last 30 days?)
- Who is the Business Owner accountable for correctness?
- How far can the existing infrastructure, budget and operations team go?

**Must have**
- [ ] `[MVP]` Use case × Data × Latency × Owner table (template E1)
- [ ] `[MVP]` List of key KPIs with definitions approved by the business
- [ ] `[MVP]` Confirmed that the platform is **not on the transaction-processing path** (it serves analytics, monitoring and reconciliation only)
- [ ] `[MVP]` 5 value metrics: time to produce a report, number of reports no longer querying sources directly, % of data meeting SLA, number of datasets actually used, time to find & fix wrong numbers

**Red flags:** starting by picking tools (Fabric/Databricks/Kafka…); "everything must be real-time"; building pipelines before KPIs are agreed.

---

### 2. Source systems

**Decisions to make**
- Which sources exist (DB, API, file, event, external)? Which tables are really needed?
- What class is each table: **Master / Transaction / Snapshot / Reference / Event**?
- What does the source support: a reliable `UPDATED_AT`? change log/CDC? read replica? load limits?

**Must have**
- [ ] `[MVP]` Inventory of sources + in-scope tables (do not sync "all thousands of tables")
- [ ] `[MVP]` For each table: business key, volume, change rate, update/delete behavior
- [ ] `[MVP]` **Verified in practice** the semantics of `UPDATED_AT` / `TXDATE` (TXDATE is a business date, not the modification time)
- [ ] `[MVP]` Load threshold on the source DB approved by the DBA; read replica/reporting DB option if needed
- [ ] `[EXP]` System ↔ dataset linkage (CMDB ↔ Catalog)

**Red flags:** reports querying operational DBs directly; continuous full loads on the Core during trading hours; assuming customer keys across systems are 1-to-1.

---

### 3. Ingestion

**Decisions to make (per table)**
- Latency axis: Batch / Micro-batch / Near real-time / Streaming?
- Capture axis: Full / Incremental / CDC / Snapshot?
- How are DELETEs captured? How is late-arriving data handled?

**Must have**
- [ ] `[MVP]` **Ingestion Strategy Matrix** for every table, with rationale (template E2)
- [ ] `[MVP]` Watermark/checkpoint stored durably (`pipeline_metadata`), **advanced only after the target write succeeds**
- [ ] `[MVP]` Safe extraction boundary `(start, end]` + overlap/lookback + dedup/upsert for late commits
- [ ] `[MVP]` Every extract carries a `batch_id`/`run_id`
- [ ] `[MVP]` DELETE capture mechanism: CDC / soft delete / periodic reconciliation / snapshot comparison
- [ ] `[MVP]` Periodic snapshots for balance/state data to preserve history
- [ ] `[MVP]` Full loads into Bronze do not truncate history; consumers never see partial data
- [ ] `[EXP]` Metadata-driven ingestion (one framework + configuration) once tables reach the hundreds
- [ ] `[EXP]` Snapshot consistency when extracting related tables (ORDER ↔ TRANSACTION)

**Red flags:** one pattern for every table; using `CREATED_AT` to catch UPDATEs; watermark = "last run time"; assuming a 5-minute schedule means data arrives within 5 minutes; spinning up Kafka for a 10-minute SLA; ingestion done = data product ready.

---

### 4. CDC *(only when needed)*

**Decisions to make**
- Why is CDC needed (high volume, continuous change, deletes, ordering/history, low latency)?
- Do you need **state sync**, **change history**, or both?
- Transport architecture: **Direct CDC** / **CDC + Kafka** / **CDC + micro-batch**? (table C3)
- Required consistency: per transaction? Is temporary skew between tables acceptable?

**Must have**
- [ ] `[PROD]` Connector verified per DB + version (Oracle ≠ Tibero), log read permissions, I/U/D capture
- [ ] `[PROD]` Supplemental logging scope chosen by DBA + Architect (not enabled everywhere)
- [ ] `[PROD]` Initial snapshot at a consistent position (SCN S0), then apply CDC **from exactly S0**
- [ ] `[PROD]` Track & monitor 3 kinds of progress separately: source position · Kafka offset · consumer checkpoint
- [ ] `[PROD]` Events with the same key go to the same partition; no global ordering assumed
- [ ] `[PROD]` Log retention & Kafka retention > maximum downtime + snapshot duration
- [ ] `[PROD]` Freshness SLA measured from `source_commit` → `consumer_visible` at a percentile (p95)
- [ ] `[PROD]` 8 metrics: capture lag, consumer lag, oldest unprocessed age, checkpoint progress, publication delay, error/retry rate, snapshot progress, log retention headroom
- [ ] `[PROD]` Recovery Matrix (table C5) + all 10 scenarios tested (Part D)

**Red flags:** CDC = Debezium + Kafka by default; "CDC adds no load"; snapshot 10:00–10:05 then read the log from 10:06; deriving SCN from offsets; claiming end-to-end exactly-once; skipping over a missing log segment.

---

### 5. Storage

**Decisions to make**
- Lightweight (existing PostgreSQL/DW) or Lakehouse (object storage + Iceberg/Delta)? (table C4 — choose by workload, not by a TB threshold)
- Is a separate DW needed for BI? What role does Lake/Lakehouse/Warehouse play?
- Retention & lifecycle (Hot/Warm/Cold) per data class?

**Must have**
- [ ] `[MVP]` The role of each storage type is documented (storage separated from engine and from product)
- [ ] `[MVP]` Bronze/Silver/Gold can be organized (schemas or folders/namespaces)
- [ ] `[EXP]` A reason for every data copy (performance, isolation, security, recovery, external delivery)
- [ ] `[EXP]` Hot/Warm/Cold lifecycle policy + retention per legal/business requirements
- [ ] `[PROD]` For Lakehouse: table-format catalog, format–engine–catalog compatibility, compaction/maintenance

**Red flags:** a lake without metadata/governance (Data Swamp); Lake = Spark, Lakehouse = Databricks; ETL chains creating copies for no reason; zero-copy as an absolute goal.

---

### 6. Medallion (Bronze / Silver / Gold)

**Decisions to make**
- What is each layer responsible for? Which layers are physically materialized, and why?
- Which shared models live in Silver (Customer, Account, Order, Trade…)?
- Which Business Data Products make up Gold?

**Must have — Bronze**
- [ ] `[MVP]` Source values kept as-is, no business-logic interpretation
- [ ] `[MVP]` Technical metadata: `source_system, ingestion_time, batch_id, source_updated_at` (+ `operation`, ordering if CDC)
- [ ] `[MVP]` Received data can be retrieved again (replay/reprocess), not only the latest state
- [ ] `[EXP]` Bronze retention based on audit, recovery and cost

**Must have — Silver**
- [ ] `[MVP]` Type standardization, dedup, handling of update/cancel/delete, normalized business dates & timestamps
- [ ] `[MVP]` Conformance: business keys mapped across sources (CUSTODYCD/CUSTOMER_CODE/CLIENT_ID → customer_id) based on **business relationships**, not just column renames
- [ ] `[MVP]` Bad records go to quarantine, never deleted without a trace
- [ ] `[EXP]` One shared model per entity (not one Customer copy per team)

**Must have — Gold**
- [ ] `[MVP]` Each Gold dataset has: metric definitions, calculation rules, `as_of_time`, intended audience, owner
- [ ] `[MVP]` Atomic publish — consumers never see a half-written batch
- [ ] `[EXP]` Cross-layer change management (Bronze/Silver changes affect many Gold products)

**Red flags:** Medallion = 3 folders; 10 TB × 3 copies; Gold = Silver with fewer columns; forcing all data through all 3 layers.

---

### 7. Orchestration

**Decisions to make**
- Triggering: schedule / event / on-demand? Which orchestrator (based on requirements, not trends)?
- Dependencies on tasks or on **data state**?
- Pipeline-centric or metadata-driven (depending on scale)?

**Must have**
- [ ] `[MVP]` Standard pipeline: Extract → Bronze → Silver → DQ → Gold → Publish
- [ ] `[MVP]` Clear dependencies: Gold does not run until required Silver is ready
- [ ] `[MVP]` Run time distinguished from data interval
- [ ] `[MVP]` Selective retry + timeouts; backfill by data range
- [ ] `[MVP]` The orchestrator only orchestrates; heavy processing runs on DB/Spark/workers
- [ ] `[EXP]` Publish conditions: upstream done → freshness → completeness → business rules
- [ ] `[EXP]` Concurrency limits / pools / priorities (Critical > Normal > Heavy batch)
- [ ] `[EXP]` Event-driven runs confirm the data is complete before processing
- [ ] `[EXP]` Metadata-driven + Metadata as Code (validation: no circular dependencies, valid dependencies, no duplicates…)
- [ ] `[PROD]` Local failures don't block unrelated branches (dependency-aware)

**Red flags:** cron + manual checks as pipelines grow; 200 tasks running at once and overloading the source; retry hard-coded in 200 DAGs; continuous streaming forced into scheduled DAGs; building a Data Control Plane on day one.

---

### 8. Data Quality

**Decisions to make**
- Which quality criteria matter for each Data Product (fit-for-purpose)?
- Which checks go in which layer? On violation: block, pass with control, or quarantine?

**Must have**
- [ ] `[MVP]` Checks per layer: Bronze (count, batch completeness, parse) · Silver (null, unique, referential, business rules) · Gold (**reconciliation** against source)
- [ ] `[MVP]` Reconciliation by count + total value + business key, on the same scope/status/point in time; difference over threshold → alert & **do not publish**
- [ ] `[MVP]` Quarantine records count, cause and resolution status
- [ ] `[EXP]` Every rule has 8 attributes: ID, meaning, scope, logic, threshold, severity, action, owner (template E4)
- [ ] `[EXP]` Gates by severity: Hard / Soft / Quarantine; data errors separated from technical errors
- [ ] `[EXP]` Rules managed centrally, definition separated from execution; domain-specific rules owned by the domain
- [ ] `[PROD]` Issue management: violation → cause → impact → assignee → status

**Red flags:** only null/duplicate checks; one rule set for every table; rigid rules with no exceptions (negative refunds); deleting bad records; every error stops the whole pipeline.

---

### 9. Data Contract & Schema evolution

**Decisions to make**
- Which producer–consumer pairs need a contract? Which changes are auto-accepted, which need approval?

**Must have**
- [ ] `[MVP]` Schema policy: adding an optional column → auto-accept; breaking change → stop/quarantine + notify
- [ ] `[EXP]` Data Contract for shared datasets: schema, semantics, quality, delivery, compatibility, ownership, security, failure handling (template E5)
- [ ] `[EXP]` 6-step process: propose → impact analysis → automated compatibility check → notify → version if breaking → post-change verification + rollback
- [ ] `[PROD]` Contract testing in CI/CD; schema registry for event streaming

**Red flags:** a contract that is just a JSON schema file; changing a field's meaning while keeping its name; "adding a column is always safe" (a required column is breaking); auto-accepting every schema change.

---

### 10. Analytical Data Model

**Decisions to make**
- Which business processes need a model? What is the **grain** of each fact?
- Fact type: Transaction / Periodic Snapshot / Accumulating Snapshot?
- Which attributes need history (SCD2), which are overwritten (SCD1)?
- Which workloads don't need a star schema (Customer 360, Risk, ML, ad-hoc)?

**Must have**
- [ ] `[MVP]` Every fact states its grain in one sentence ("1 row = 1 trade execution")
- [ ] `[MVP]` Every measure declares its type: additive / semi-additive (not summed over time) / non-additive (recomputed from numerator/denominator)
- [ ] `[MVP]` Shared conformed dimensions (customer, account, security, branch, date)
- [ ] `[MVP]` Agreed rules for cancelled/amended/adjusted/reversed transactions
- [ ] `[EXP]` Surrogate keys for multi-source/history; SCD2 with rules for retroactive changes
- [ ] `[EXP]` CDC into the model: current-state → upsert/delete; event history → append/dedup
- [ ] `[EXP]` Policies for late facts, late dimensions (unknown/inferred member), restatement (restated vs as-published)
- [ ] `[EXP]` Risk metrics share a single data point in time
- [ ] `[PROD]` Model metadata: owner, lineage, schema version, refresh SLA, consumers, deprecation policy

**Red flags:** copying the OLTP schema as the model; joining 2 facts of different grain (fan-out); summing balances across days; averaging ratios; joining the current branch for historical data; MERGE-overwriting an event history table.

---

### 11. Semantic Layer & Metrics

**Decisions to make**
- Which metrics are official, and who owns them? Time semantics (order/trade/settlement/accounting date)?
- Implemented how: SQL views, BI semantic model, metrics layer/API?
- Architecture: Centralized / Domain / Hybrid?

**Must have**
- [ ] `[MVP]` Key KPIs defined in one place (SQL view or BI semantic model); dashboards don't recompute them
- [ ] `[EXP]` Metric Contract: meaning, grain, time semantics, filters, aggregation, owner, version (template E6)
- [ ] `[EXP]` Metric Registry (owner, status, version) + change approval process
- [ ] `[EXP]` Business calendar (trading days, holidays, settlement) from an authoritative source
- [ ] `[EXP]` Consistency tests across consumers (BI = SQL = API)
- [ ] `[PROD]` Metrics as Code: Git, PRs, 6 test types (definition, SQL, aggregation, reconciliation, regression, access), staging
- [ ] `[PROD]` AI agents access data only through governed metrics/query interfaces

**Red flags:** same Lakehouse but 3 dashboards show 3 different numbers; one name for 2 metrics with different time semantics; computing by processing time; changing definitions without versioning; counting metrics as a measure of success.

---

### 12. Data Product

**Decisions to make**
- Which datasets deserve to be Data Products (real users, clear value)?

**Must have**
- [ ] `[EXP]` Each Data Product has: purpose, owner, schema & definitions, quality rules, refresh frequency/SLO, access method, version (template E7)
- [ ] `[EXP]` Discoverable via the catalog; consumers & dependencies recorded
- [ ] `[PROD]` Meets the 6 properties: Discoverable, Addressable, Self-describing, Trustworthy, Interoperable, Secure
- [ ] `[PROD]` KPIs: adoption, time to publish, SLO compliance, contract violations, cross-domain reuse, cost per product

**Red flags:** turning every table into a Data Product; hundreds of products nobody uses.

---

### 13. Governance: Catalog, Lineage, Ownership

**Decisions to make**
- Who is the Business Owner / Technical Owner / Steward for each important dataset?
- Which classification scale? How is lineage collected?

**Must have**
- [ ] `[MVP]` 8 metadata fields for important datasets: name, business owner, technical owner, source, refresh, business definition, classification, retention (template E9)
- [ ] `[MVP]` Minimal lineage: a pipeline – source – target – consumer table
- [ ] `[MVP]` Ownership assigned to a **team/domain** + one contact person
- [ ] `[EXP]` Governance by Design: new datasets must have purpose, owner, classification before publishing
- [ ] `[EXP]` Metadata auto-registered on pipeline deploy; business glossary linked to the semantic layer
- [ ] `[EXP]` Impact analysis (downstream lineage) before any schema change
- [ ] `[PROD]` Column-level lineage for critical flows; coverage published
- [ ] `[PROD]` Processes for: owner change, orphaned datasets, definition disputes, data incidents
- [ ] `[PROD]` KPIs: ownership / metadata / classification / lineage coverage, orphan count, exception aging

**Red flags:** having a Catalog = having governance; DEs choosing definitions when the business hasn't agreed; ownership assigned to individuals; believing lineage is 100% complete; pipelines run fine but ownership coverage is 20%.

---

### 14. Security & Access

**Decisions to make**
- Who can see detailed customer/transaction data, who only sees aggregates?
- Permissions at dataset / row / column level? Which data needs masking/encryption?

**Must have**
- [ ] `[MVP]` Minimal role-based access (RBAC); no secrets in code
- [ ] `[MVP]` Classification: Public / Internal / Confidential / Restricted for important datasets
- [ ] `[EXP]` Classification tied to **enforcement**: RLS, CLS, masking/tokenization, encryption
- [ ] `[EXP]` Consistent permissions across BI, SQL, API
- [ ] `[PROD]` Audit logging, periodic access reviews, retention & legal hold, deletion across all copies (backups, replicas, exports)
- [ ] `[PROD]` Review against current regulations (e.g. the securities regulator's IT system security requirements)

**Red flags:** labeling data Restricted and calling it done; assuming aggregated data is safe to publish; one security configuration for every data type.

---

### 15. Recovery: Idempotency, Replay, Backfill

**Decisions to make**
- RPO, RTO and freshness SLO for each dataset (three different things)?
- Recompute the whole partition or apply deltas?
- Replay from where (immutable Bronze or broker retention)?

**Must have**
- [ ] `[MVP]` Re-running the same data range does not duplicate results (MERGE by business key / partition overwrite / stage then merge)
- [ ] `[MVP]` Aggregates are recomputed from detail and **assigned**, never `total = total + delta`
- [ ] `[MVP]` Backfill a single day/partition without reloading everything
- [ ] `[MVP]` Gold failed but Silver OK → rebuild Gold from Silver
- [ ] `[EXP]` `pipeline_runs` registry; SUCCEEDED written only when output is committed, readable, and checks have passed (template E3)
- [ ] `[EXP]` Dedup by **event identity**; apply state by business key + version (older versions arriving later never overwrite)
- [ ] `[EXP]` Retry: exponential backoff, jitter, max attempts, timeout; error classification (table C6)
- [ ] `[EXP]` Execution contract per task: input, verifiable output, commit rule, retry, recovery, concurrent-write protection
- [ ] `[PROD]` 8-step backfill: approve scope → logic version → source snapshot → execution → isolated output → validate → atomic switch → audit (`logic_version, source_snapshot, execution_id, reason`)
- [ ] `[PROD]` Closed financial periods are overwritten only with business approval
- [ ] `[PROD]` Reconcile after every recovery

**Red flags:** "we use MERGE so it's idempotent"; "Airflow already retries"; dedup by `trade_id` losing valid updates; relying on Kafka retention to replay months of data; deleting the old partition before the new result is ready; backfilling with hand-written scripts.

---

### 16. Observability & Operations

**Decisions to make**
- Which pipelines/datasets matter most? Expected freshness of each dataset?
- Who receives alerts, at what level? Which existing monitoring tools can be reused?

**Must have**
- [ ] `[MVP]` Run log: status, duration, `rows_read`, `rows_written`, `last_watermark`
- [ ] `[MVP]` **Freshness check** against each dataset's SLA, trading-calendar aware (no stale alerts on holidays)
- [ ] `[MVP]` Alerts when a pipeline fails or data is late; alerts include pipeline, env, task, time, error, log link, affected data product (template E11)
- [ ] `[MVP]` One dashboard: are pipelines running, is data fresh, is data trustworthy
- [ ] `[MVP]` Runbooks for common incidents (template E10)
- [ ] `[EXP]` Volume vs baseline (by day of week, trading calendar); duration vs baseline
- [ ] `[EXP]` Infrastructure metrics: DB (connections, long queries, ingestion load), Kafka (consumer lag), Spark, Airflow (queue, scheduler)
- [ ] `[EXP]` Alert levels Critical / Warning / Info; grouped into one incident by root cause (no alert storms)
- [ ] `[PROD]` Data Product SLOs + error budgets (template E8)
- [ ] `[PROD]` Lineage-based impact (blast radius), correlation, RCA; incident lifecycle Detect → Correlate → Impact → Investigate → Remediate → Verify
- [ ] `[PROD]` Automated remediation only with idempotency, limits, audit, rollback, approval; AI only suggests

**Red flags:** tracking only SUCCESS/FAILED; fixed thresholds that ignore month-end; bare "DAG FAILED" alerts; jumping straight to ML/AIOps; deploying Prometheus + Grafana + ELK + OpenTelemetry all at once.

---

### 17. Performance & Cost

**Decisions to make**
- Always-on or on-demand compute? Real-time or is batch enough? Hot or cold?

**Must have**
- [ ] `[MVP]` Storage size and growth monitored
- [ ] `[EXP]` Time-based partitioning (when it fits query patterns), incremental processing, selective aggregate tables
- [ ] `[EXP]` Cost broken down by workload / domain / data product
- [ ] `[PROD]` Unit cost (per 1M records, per data product) — compared only across similar workloads
- [ ] `[PROD]` Evidence-based tuning (skew, shuffle, spill, execution plan), balancing cost ↔ freshness SLO

**Red flags:** looking only at the total bill; every dashboard scanning years of data; too many aggregate tables; adding CPU/RAM by gut feeling.

---

### 18. Delivery (Git, CI/CD, environments) & Organization

**Decisions to make**
- How are roles split between Data Engineering/IT and Business/Data Owners (even when one person wears several hats)?
- Organization model: Centralized / Domain ownership + shared platform / Data Mesh? (table C7)

**Must have**
- [ ] `[MVP]` SQL, DAGs, code and config in Git; no manual edits in production
- [ ] `[MVP]` A way to test before production (even without 3 full environments)
- [ ] `[MVP]` Clear roles: DE builds & operates; Business defines, approves KPIs, signs off outputs
- [ ] `[EXP]` CI/CD: schema/contract validation, unit & data tests, integration tests, approval
- [ ] `[PROD]` If adopting Mesh: all 4 pillars (domain ownership, data as a product, self-serve platform, federated governance via policy as code); ownership comes with people + budget + decision rights

**Red flags:** Big Bang — building everything before the first report; Mesh = splitting the DW; every domain running its own Kafka/Airflow/Spark; Mesh with only 5 sources and 1 DE team.

---

## Part C — Quick decision tables

### C1. Ingestion per table
| Situation | Choose |
|---|---|
| Small, rarely changing table (catalogs, holidays, branches) | Scheduled Full Load |
| Large table with a reliable `UPDATED_AT` | Incremental (+ overlap + dedup) |
| Continuous changes, need update/delete/ordering, no reliable timestamp | CDC |
| Balances/state that need history | Periodic snapshot |
| Continuous events needing second-level latency | Streaming |
| Updates every few minutes | Frequent batch / micro-batch |
| No timestamp, no change log | Snapshot comparison / lookback / business date (only if truly append-only) |

### C2. Latency
`hours/days → Batch` · `minutes → Micro-batch` · `seconds + high volume + continuous change → evaluate CDC/Streaming`. Latency is a **business requirement**; end-to-end = capture + transport + ingestion + processing + serving.

### C3. CDC transport
| | Direct CDC | CDC + Kafka | CDC + Micro-batch |
|---|---|---|---|
| Fits when | One main target, fewer components wanted | Many consumers, need buffering/replay | Minute-level analytics |
| Trade-off | Connector dependency, replay/fan-out depends on solution | Must operate cluster, partitions, retention, lag, schemas | Latency tied to the processing cycle |

### C4. Lightweight vs Lakehouse
| Criterion | Lightweight (PostgreSQL/DW) | Lakehouse (Object storage + Iceberg/Delta + Spark/Trino) |
|---|---|---|
| Moderate data, SQL reporting | ✅ | May be overkill |
| Very large history, heavy transforms, multiple engines | Needs evaluation | ✅ |
| Small team, low initial cost | ✅ | More complex |

### C5. Recovery Matrix (CDC/streaming)
| Failure | Response |
|---|---|
| Connector crash | Resume from source position if the log is still available |
| Source log expired | Resnapshot / reconciliation |
| Consumer crash | Resume from checkpoint + idempotent replay |
| Target commit failure | Retry/rollback per transaction semantics |
| Incompatible schema | Stop/isolate, update mapping, replay |
| Prolonged lag | Scale, clear backlog before exceeding retention |

### C6. Error type → action
| Error | Action |
|---|---|
| Transient (timeout) | Retry + backoff |
| Resource (worker died) | Restart, restore state |
| Data (bad schema/format) | Quarantine → fix → reprocess |
| Logic (wrong transform) | Fix → replay/backfill |
| Source down | Wait, backoff, alert |
| Partial commit | Reconcile + idempotent recovery |
| Missing/wrong output | Rebuild the affected scope |

### C7. Organization model
| Scale \ sharing needs | Low | High |
|---|---|---|
| Small, few domains | Centralized | Centralized + Data Product standards |
| Large, many domains | Domain ownership + shared platform | Evaluate full Data Mesh |

### C8. Roadmap
| | MVP | Expansion | Production |
|---|---|---|---|
| Sources / use cases | 1–2 / 1 (e.g. Daily Trading) | 3–5 / Customer 360, Margin, Portfolio | As needed |
| Stack | Python → PostgreSQL B/S/G → SQL → BI, Airflow | + object storage, CDC where needed, catalog, DQ framework | + optimization, DR, CI/CD, SLA & incident mgmt |
| Checklist to meet | All `[MVP]` items (in 1–3, 5–11, 13–18) | + all `[EXP]` items (adds 12) | + all `[PROD]` items (adds 4 if using CDC) |

---

## Part D — Go-live gate

Do not go live while any **Mandatory** box is unchecked.

**Mandatory (every platform)**
- [ ] Gold ↔ source reconciliation matches per the agreed rules
- [ ] Re-running any batch/data range creates no duplicates and loses no data
- [ ] Checkpoint/watermark advances only after commit (tested by killing mid-run)
- [ ] Alerts when a pipeline fails and when data exceeds its freshness SLA
- [ ] Runbooks for "dataset not updated" and "numbers don't match"
- [ ] Business & technical owner for every published dataset
- [ ] Business has confirmed reports/KPIs match the definitions
- [ ] Load on source systems within the approved threshold

**Mandatory if using CDC/streaming — test all 10 scenarios**
Restart connector · restart consumer · target write failure · duplicate event replay · lag over threshold · retention nearly exhausted · source log lost · schema change · initial snapshot failure · source failover.
Record for each scenario: Detection · Impact · Recovery procedure · Reconciliation · Acceptance criteria.

**Sample acceptance criteria (CDC)**
| Criterion | Illustrative target |
|---|---|
| Order freshness | p95 ≤ 30s |
| Capture completeness | No committed change missed |
| Duplicate handling | Replay does not corrupt target state |
| Connector recovery | Resumes from a valid checkpoint |
| Source impact | Within the DBA-approved threshold |

---

## Part E — Templates

### E1. Use case × Latency
| Use case | Data needed | Target latency | Business owner |
|---|---|---|---|
| Daily Trading Report | Executions, trades | End of day (after reconciliation) | Trading Ops |
| Margin Exposure | Loans, collateral, prices | 5–10 min | Risk |
| Customer 360 | CRM, accounts, trades, assets | 15–60 min | Business/CRM |

### E2. Ingestion Strategy Matrix (1 row / table)
```yaml
- source_system: ORACLE_CORE
  source_table: TRADING.ORDERS
  target: bronze.orders
  data_class: transaction        # master | transaction | snapshot | reference | event
  load_strategy: cdc             # full | incremental | cdc | snapshot | streaming
  primary_key: [ORDER_ID]
  watermark_column: null         # e.g. UPDATED_AT (verified reliable)
  delete_capture: true
  freshness_sla_minutes: 5
  initial_load: snapshot_at_scn
  reason: "100M rows, ~20k changes/5 min, has cancels/amendments"
```

### E3. Progress table & run registry
```sql
pipeline_metadata(source, table_name, last_watermark, status, run_time, row_count)

pipeline_runs(run_id PK, pipeline_name, window_start, window_end, status,
              started_at, completed_at, rows_read, rows_written,
              logic_version, error_message)
-- PENDING → RUNNING → (FAILED → RETRYING → RUNNING) → SUCCEEDED
```

### E4. DQ Rule
```yaml
rule_id: DQ_TRADE_001
business_meaning: "Every trade has a unique identifier"
scope: silver.trades
logic: "group by trade_id having count(*) > 1"
threshold: 0
severity: critical
failure_action: hard_gate     # hard_gate | soft_gate | quarantine
owner: trading_data_team
```

### E5. Data Contract
```yaml
dataset: transactions
producer: core_trading_team
consumers: [risk, finance_bi]
schema: {transaction_id: {type: string, required: true, unique: true}}
semantics: "transaction_amount = matched price × quantity, VND, excluding fees/taxes"
quality_rules: [DQ_TRADE_001]
delivery: {frequency: 5m, deadline: "p95 ≤ 10m"}
compatibility: "optional column OK; breaking needs approval + new version"
security: {classification: confidential}
failure_handling: "notify, quarantine, replay after fix"
```

### E6. Metric Contract
```yaml
metric: total_trading_value
owner: trading_analytics
source_model: fact_trade
grain: "one row per matched execution"
measure: {column: matched_value, aggregation: sum}
time_dimension: trade_date
filters: ["eligible_trade = true"]
dimensions: [branch, customer_segment, security]
unit: VND
status: approved
version: 1.0.0
```

### E7. Data Product manifest
```yaml
name: trading-executed-orders
domain: trading
version: 1.2.0
owner: trading-data
contract: contracts/transactions.yaml
slo: {freshness: 5m, availability: 99.9%}
classification: confidential
access: {interface: sql, approval_required: true}
consumers: [risk, finance]
```

### E8. SLO
```yaml
data_product: daily_trading_summary
freshness: {publish_before: "08:00 Asia/Ho_Chi_Minh, business days", target: 99.5%}
completeness: {min_reconciliation_ratio: 0.999}
rpo: "no committed change missed"
rto: 30m
```

### E9. Governance — 8 minimum fields
Dataset Name · Business Owner · Technical Owner · Source System · Refresh Frequency · Business Definition · Data Classification · Retention Policy

### E10. Runbook "Dataset not updated"
1. Status of the latest run (failed → check logs)
2. Last update time vs SLA
3. Compare `rows_read` / `rows_written`
4. Watermark/checkpoint of the latest run
5. Source connectivity & data (any new data? holiday?)
6. Decide retry / replay / backfill → reconcile → close the incident

### E11. Sample alert
`[CRITICAL] Pipeline Failed – trading_daily_sync – prod – task load_silver – 10:15 – DB connection timeout – <log link> – impact: Daily Trading Summary`
