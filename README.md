# Skill Verification Smart Contract

### Overview
The Skill Verification Smart Contract is a decentralized application designed to facilitate the creation of assessments, submission of student answers, and issuance of skill badges upon successful completion of assessments. This contract aims to provide a transparent and secure method for institutions to validate student skills and competencies on the blockchain.

### Features
Assessment Creation: Institutions can create assessments with detailed descriptions.
Answer Submission: Students can submit answers to assessments and track their submission status.
Review Process: Institutions can review student submissions and determine if a badge should be issued based on performance.
Badge Issuance: Upon passing an assessment, students receive a skill badge that can be verified on the blockchain.
Data Integrity: Input validation and error handling mechanisms ensure the reliability of the data stored on-chain.
Contract Structure
Data Structures
Assessments Map: Stores assessment details (creator, description, is-active status).
Submissions Map: Tracks student answers, reviewed status, and pass/fail outcomes.
Badges Map: Manages issued badges, including student, assessment IDs, and issuer details.
Constants
Defines constants for common error scenarios, including:

Unauthorized access
Assessment not found
Duplicate submissions
Invalid inputs
Core Functions
create-assessment: Allows institutions to create a new assessment.

Validates input length for the assessment description.
Automatically increments the assessment counter upon creation.
submit-answer: Enables students to submit answers to assessments.

Validates the assessment ID and answer length.
Ensures that students cannot submit answers multiple times for the same assessment.
review-submission: Institutions can review student submissions and issue badges based on performance.

Validates the assessment ID and checks if the student’s submission has already been reviewed.
issue-badge: Issues a badge to students who pass an assessment.

Validates the student’s principal identity before issuing the badge.
verify-badge: Allows anyone to verify if a student has received a badge for a particular assessment.

### Getting Started
Prerequisites
Clarinet: A tool for developing Clarity smart contracts.
Stacks CLI: For deploying and interacting with Stacks blockchain.
Installation
Clone the repository:

git clone <repository-url>
cd skill-verification
Install dependencies (if necessary):


npm install
Testing the Contract
Run the following command to check the syntax of the contract:


clarinet check
Deploying the Contract
To deploy the contract, use the following command:

Create Assessment:


(create-assessment "Introduction to Blockchain")
Submit Answer:


(submit-answer 1 "Blockchain is a distributed ledger technology.")
Review Submission:


(review-submission 1 tx-sender true)
Verify Badge:


(verify-badge tx-sender 1)
Contributing
Contributions are welcome! Please open an issue or submit a pull request to discuss any changes or improvements.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgements
Stacks for providing the blockchain infrastructure.
Clarinet for its robust development tools.
