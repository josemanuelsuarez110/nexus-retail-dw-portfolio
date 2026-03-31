import pandas as pd
import numpy as np
import os
import uuid
import logging
from datetime import datetime, timedelta

# Set up logging for professional tracking
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class NexusIngestionPipeline:
    def __init__(self, output_dir="data_bronze"):
        self.output_dir = output_dir
        if not os.path.exists(self.output_dir):
            os.makedirs(self.output_dir)
            logger.info(f"Created directory {self.output_dir}")

    def generate_customers(self, n=1000):
        """Simulates raw customer data."""
        logger.info(f"Generating {n} customers...")
        customers = {
            'customer_id': [str(uuid.uuid4())[:8] for _ in range(n)],
            'full_name': [f"Customer {i}" for i in range(n)],
            'email': [f"customer_{i}@example.com" for i in range(n)],
            'country': np.random.choice(['USA', 'CAN', 'UK', 'GER', 'FRA'], n),
            'registration_date': [datetime.now() - timedelta(days=np.random.randint(0, 730)) for _ in range(n)],
            'ingested_at': datetime.now()
        }
        df = pd.DataFrame(customers)
        return df

    def generate_orders(self, customer_ids, n=5000):
        """Simulates raw order data linked to customers."""
        logger.info(f"Generating {n} orders...")
        orders = {
            'order_id': [str(uuid.uuid4())[:12] for _ in range(n)],
            'customer_id': np.random.choice(customer_ids, n),
            'order_date': [datetime.now() - timedelta(days=np.random.randint(0, 365)) for _ in range(n)],
            'amount': np.round(np.random.uniform(10.0, 500.0, n), 2),
            'status': np.random.choice(['completed', 'pending', 'cancelled', 'returned'], n, p=[0.7, 0.15, 0.1, 0.05]),
            'ingested_at': datetime.now()
        }
        df = pd.DataFrame(orders)
        return df

    def run_full_extraction(self):
        """Executes the full simulated extraction to Bronze storage."""
        try:
            # 1. Extract Customers
            customers_df = self.generate_customers()
            cust_path = os.path.join(self.output_dir, "raw_customers.csv")
            customers_df.to_csv(cust_path, index=False)
            logger.info(f"Saved customers to {cust_path}")

            # 2. Extract Orders
            orders_df = self.generate_orders(customers_df['customer_id'].tolist())
            orders_path = os.path.join(self.output_dir, "raw_orders.csv")
            orders_df.to_csv(orders_path, index=False)
            logger.info(f"Saved orders to {orders_path}")

            logger.info("Extraction Pipeline Completed Successfully ✅")

        except Exception as e:
            logger.error(f"Error during extraction: {str(e)}")

if __name__ == "__main__":
    pipeline = NexusIngestionPipeline()
    pipeline.run_full_extraction()
