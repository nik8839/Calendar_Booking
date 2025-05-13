class Booking {
  constructor(userId, startTime, endTime) {
    this.id = `booking-${Math.random().toString(36).substr(2, 9)}`;
    this.userId = userId;
    this.startTime = new Date(startTime);
    this.endTime = new Date(endTime);
  }
}
module.exports = Booking;
