
struct BorrowInfomation{
    uint256 amountBorrowed;
    uint256 lastBorrowTime;
    uint256 dailyBorrowLimit;
    bool hasBorrowedToday;
}

mapping(uint256 => BorrowInformation) public listingIdToBorrowInfo;