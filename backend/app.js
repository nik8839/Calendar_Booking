const express = require('express');
const app = express();
const dotenv = require('dotenv');
dotenv.config();
const bookingRoutes = require('./routes/bookingRoutes');
const cors = require('cors');
const port=process.env.PORT||5000;
app.use(cors());

app.use(express.json());
app.use('/bookings', bookingRoutes);

const PORT = port
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
