const bookings = require('../data/bookings');
const Booking = require('../models/Booking');

exports.getAllBookings = (req, res) => {
  res.json(bookings);
};

exports.getBookingById = (req, res) => {
  const booking = bookings.find(b => b.id === req.params.bookingId);
  if (!booking) return res.status(404).json({ error: 'Booking not found' });
  res.json(booking);
};

exports.createBooking = (req, res) => {
  const { userId, startTime, endTime } = req.body;
  if (!userId || !startTime || !endTime) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const start = new Date(startTime);
  const end = new Date(endTime);
  if (isNaN(start.getTime()) || isNaN(end.getTime()) || start >= end) {
    return res.status(400).json({ error: 'Invalid date format or time logic' });
  }

  const conflict = bookings.find(b =>
    (start < b.endTime && end > b.startTime)
  );

  if (conflict) {
    return res.status(409).json({ error: 'Time conflict with existing booking' });
  }

  const newBooking = new Booking(userId, startTime, endTime);
  bookings.push(newBooking);
  res.status(201).json(newBooking);
};
