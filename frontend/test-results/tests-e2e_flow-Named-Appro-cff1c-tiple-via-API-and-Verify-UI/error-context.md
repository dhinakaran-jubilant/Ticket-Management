# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: tests\e2e_flow.spec.js >> Named Approvals and Management Status >> Step 3: Approve as Management (Multiple) via API and Verify UI
- Location: tests\e2e_flow.spec.js:179:5

# Error details

```
Error: expect(locator).toBeVisible() failed

Locator: locator('text=Annie: Approved, Vanjinathan: Approved')
Expected: visible
Timeout: 5000ms
Error: element(s) not found

Call log:
  - Expect "toBeVisible" with timeout 5000ms
  - waiting for locator('text=Annie: Approved, Vanjinathan: Approved')

```

# Page snapshot

```yaml
- generic [ref=e3]:
  - banner [ref=e4]:
    - generic [ref=e6]:
      - link "Logo" [ref=e7] [cursor=pointer]:
        - /url: /
        - img "Logo" [ref=e8]
      - button "Toggle dark mode" [ref=e10] [cursor=pointer]:
        - generic [ref=e11]: dark_mode
  - main [ref=e12]:
    - generic [ref=e13]:
      - generic [ref=e14]:
        - generic [ref=e15]:
          - generic [ref=e17] [cursor=pointer]: search_check
          - heading "Check Ticket Status" [level=1] [ref=e18]
          - paragraph [ref=e19]: Search by Ticket ID or your registered mobile number.
        - generic [ref=e20]:
          - button "tag Ticket ID" [ref=e21] [cursor=pointer]:
            - generic [ref=e22]: tag
            - text: Ticket ID
          - button "smartphone Mobile Number" [ref=e23] [cursor=pointer]:
            - generic [ref=e24]: smartphone
            - text: Mobile Number
        - generic [ref=e25]:
          - generic [ref=e26]:
            - generic [ref=e27]: Ticket ID
            - generic [ref=e28]:
              - generic:
                - generic: tag
              - textbox "Ticket ID" [ref=e29]:
                - /placeholder: e.g. AB12CD34
          - button "Track Status" [ref=e30] [cursor=pointer]
      - generic [ref=e32]:
        - generic [ref=e33]: info
        - text: Looking for a new ticket?
        - link "Click here" [ref=e34] [cursor=pointer]:
          - /url: /
    - link "arrow_back Back to Home" [ref=e36] [cursor=pointer]:
      - /url: /
      - generic [ref=e37]: arrow_back
      - text: Back to Home
  - contentinfo [ref=e38]:
    - paragraph [ref=e39]: © 2024 Support Desk Inc. All rights reserved.
```

# Test source

```ts
  94  |         
  95  |         // Success notification (toast)
  96  |         await expect(page.locator('text=Ticket updated successfully')).toBeVisible();
  97  |     });
  98  | 
  99  |     test('Step 4: Verify status update on Check Status page', async ({ page }) => {
  100 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  101 | 
  102 |         // Verify status is now "Completed"
  103 |         await expect(page.locator('text=Completed')).toBeVisible();
  104 |         await expect(page.locator('text=Issue resolved by E2E test script.')).toBeVisible();
  105 |     });
  106 | 
  107 |     test('Step 5: Verify email notification content', async ({ request }) => {
  108 |         // Fetch the last sent email from the backend test endpoint
  109 |         const response = await request.get('http://127.0.0.1:443/api/test/last-email');
  110 |         expect(response.ok()).toBeTruthy();
  111 |         
  112 |         const emailData = await response.json();
  113 |         console.log('Last sent email:', emailData);
  114 |         
  115 |         // Verify email details
  116 |         expect(emailData.to).toContain('e2e@example.com');
  117 |         expect(emailData.subject).toContain('Resolved');
  118 |         expect(emailData.subject).toContain(ticketId);
  119 |         expect(emailData.body).toContain('Issue resolved by E2E test script.');
  120 |         expect(emailData.body).toContain('Ruban');
  121 |     });
  122 | });
  123 |  
  124 | test.describe('Named Approvals and Management Status', () => {
  125 |     let ticketId = '';
  126 |  
  127 |     test('Step 1: Create a Material Request ticket', async ({ page }) => {
  128 |         await page.goto('http://localhost:5173/');
  129 |  
  130 |         // Handle Branch Popup
  131 |         const supportTypeSelect = page.locator('div.fixed select').first();
  132 |         await supportTypeSelect.waitFor({ state: 'visible' });
  133 |         await supportTypeSelect.selectOption('IT Support');
  134 |         const branchSelect = page.locator('div.fixed select').nth(1);
  135 |         await branchSelect.selectOption('Cotton Concepts HO, Coimbatore');
  136 |         await page.click('button:has-text("Next")');
  137 |  
  138 |         // Fill form with Category that requires approvals
  139 |         await page.waitForSelector('input#fullName', { state: 'visible' });
  140 |         await page.fill('input#fullName', 'Named Approval Test');
  141 |         await page.fill('input#email', 'named-test@example.com');
  142 |         await page.fill('input#mobile', '1122334455');
  143 |  
  144 |         const categorySelect = page.locator('select#category');
  145 |         await expect(categorySelect.locator('option').nth(1)).toBeAttached();
  146 |         await categorySelect.selectOption('Hardware/Assets'); // Requires approvals
  147 |  
  148 |         const departmentSelect = page.locator('select#department');
  149 |         await expect(departmentSelect.locator('option').nth(1)).toBeAttached();
  150 |         await departmentSelect.selectOption('Admin & IT');
  151 |  
  152 |         await page.fill('textarea#description', 'Named approval verification ticket.');
  153 |         await page.click('button:has-text("Submit Ticket")');
  154 |  
  155 |         const ticketIdContainer = page.locator('div.fixed span.tracking-widest').first();
  156 |         await expect(ticketIdContainer).toBeVisible({ timeout: 10000 });
  157 |         ticketId = (await ticketIdContainer.innerText()).trim();
  158 |         console.log(`Named Approval Ticket ID: ${ticketId}`);
  159 |     });
  160 |  
  161 |     test('Step 2: Approve as Manager via API and Verify UI', async ({ page, request }) => {
  162 |         // Approve via API
  163 |         const response = await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Admin-Manager`, {
  164 |             form: {
  165 |                 action: 'Approve',
  166 |                 comments: 'Looks good to me',
  167 |                 receiver_name: 'Balaji Manager'
  168 |             }
  169 |         });
  170 |         expect(response.ok()).toBeTruthy();
  171 |  
  172 |         // Go to status page
  173 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  174 |  
  175 |         // Verify named status is visible
  176 |         await expect(page.locator('text=Balaji Manager: Approved')).toBeVisible();
  177 |     });
  178 |  
  179 |     test('Step 3: Approve as Management (Multiple) via API and Verify UI', async ({ page, request }) => {
  180 |         // Management 1
  181 |         await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Management`, {
  182 |             form: { action: 'Approve', comments: 'Approve 1', receiver_name: 'Annie' }
  183 |         });
  184 |  
  185 |         // Management 2
  186 |         await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Management`, {
  187 |             form: { action: 'Approve', comments: 'Approve 2', receiver_name: 'Vanjinathan' }
  188 |         });
  189 |  
  190 |         // Go to status page
  191 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  192 |  
  193 |         // Verify appended named status
> 194 |         await expect(page.locator('text=Annie: Approved, Vanjinathan: Approved')).toBeVisible();
      |                                                                                   ^ Error: expect(locator).toBeVisible() failed
  195 |     });
  196 | });
  197 | 
```