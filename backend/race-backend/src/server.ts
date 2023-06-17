import { createApp } from "./app";

const app = createApp();

// init
const PORT = process.env.PORT || 5500;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}.`);
});
