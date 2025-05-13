const express = require('express');
const router = express.Router();
const controller = require('../controllers/bookingController');

router.get('/', controller.getAllBookings);
router.get('/:bookingId', controller.getBookingById);
router.post('/', controller.createBooking);

module.exports = router;
