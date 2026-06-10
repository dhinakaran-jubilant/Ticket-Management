import sys
import os
import uuid

# Add backend to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from database import (
    append_to_sheet, 
    update_ticket_details, 
    get_ticket_by_id, 
    init_db,
    create_admin_user,
    update_admin_user,
    verify_admin_login,
    get_admin_users,
    delete_admin_user
)

def test_user_rejection_moves_to_pending():
    init_db()
    
    ticket_id = f"TEST{uuid.uuid4().hex[:6].upper()}"
    data = {
        "ticket_id": ticket_id,
        "fullName": "Test User",
        "mobile": "1234567890",
        "category": "Test",
        "mode": "Test",
        "description": "Test ticket"
    }
    
    # 1. Create ticket
    append_to_sheet(data)
    
    # 2. Mark as Completed
    update_ticket_details(ticket_id, {"status": "Completed"})
    ticket = get_ticket_by_id(ticket_id)
    assert ticket["status"] == "Completed"
    
    # 3. User marks "No"
    update_ticket_details(ticket_id, {"user_confirmation": "No"})
    
    # 4. Verify status changed to Pending
    ticket = get_ticket_by_id(ticket_id)
    assert ticket["status"] == "Pending"
    assert ticket["userConfirmation"] == "No"
    assert ticket["pendingTime"] != ""
    
    print(f"Successfully verified ticket {ticket_id} moved to Pending on rejection.")

def test_employee_code_saved_and_retrieved():
    init_db()
    
    ticket_id = f"TEST{uuid.uuid4().hex[:6].upper()}"
    data = {
        "ticket_id": ticket_id,
        "fullName": "Test User With Emp Code",
        "empCode": "EMP98765",
        "mobile": "1234567890",
        "category": "Test",
        "mode": "Test",
        "description": "Test ticket for employee code"
    }
    
    # 1. Create ticket
    res = append_to_sheet(data)
    assert res.get("success") is True
    
    # 2. Get ticket and verify empCode
    ticket = get_ticket_by_id(ticket_id)
    assert ticket is not None
    assert ticket["fullName"] == "Test User With Emp Code"
    assert ticket["empCode"] == "EMP98765"
    
    print(f"Successfully verified ticket {ticket_id} contains empCode EMP98765.")

def test_admin_user_emp_code():
    init_db()
    
    email = f"test-admin-{uuid.uuid4().hex[:6]}@example.com"
    name = "Test Admin User"
    password = "Password@123"
    emp_code = "EMP10001"
    
    # 1. Create admin user
    res = create_admin_user(name, email, password, emp_code=emp_code)
    user_id = res.get("id")
    assert user_id is not None
    
    # 2. Verify login and empCode retrieval
    login_info = verify_admin_login(email, password)
    assert login_info is not None
    assert login_info["name"] == name
    assert login_info["empCode"] == emp_code
    
    # 3. Check get_admin_users list
    all_users = get_admin_users()
    matched = next((u for u in all_users if u["id"] == user_id), None)
    assert matched is not None
    assert matched["emp_code"] == emp_code
    
    # 4. Update admin user (update empCode)
    new_emp_code = "EMP10002"
    updated = update_admin_user(user_id, name, email, password="", access="View", support_type="IT Support", emp_code=new_emp_code)
    assert updated is True
    
    # 5. Verify update after login
    login_info = verify_admin_login(email, password)
    assert login_info["empCode"] == new_emp_code
    
    # 6. Cleanup
    deleted = delete_admin_user(user_id)
    assert deleted is True
    print("Successfully verified admin user emp_code CRUD operations.")

if __name__ == "__main__":
    test_user_rejection_moves_to_pending()
    test_employee_code_saved_and_retrieved()
    test_admin_user_emp_code()

