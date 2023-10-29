CREATE TABLE IF NOT EXISTS Tool
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    stock INTEGER      NOT NULL
);

CREATE TABLE IF NOT EXISTS Offer
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price       INTEGER      NOT NULL
);

CREATE TABLE IF NOT EXISTS OfferTool
(
    offerId INTEGER NOT NULL,
    toolId  INTEGER NOT NULL,
    CONSTRAINT offerId_fk FOREIGN KEY (offerId) REFERENCES Offer (id) ON DELETE CASCADE,
    CONSTRAINT toolId_fk FOREIGN KEY (toolId) REFERENCES Tool (id) ON DELETE CASCADE,
    CONSTRAINT offerToolId PRIMARY KEY (
                                        offerId, toolId
        )
);

CREATE TABLE IF NOT EXISTS Detail
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    stock INTEGER      NOT NULL,
    price INTEGER      NOT NULL
);

CREATE TABLE IF NOT EXISTS OfferDetail
(
    offerId  INTEGER NOT NULL,
    detailId INTEGER NOT NULL,
    CONSTRAINT offerId_fk FOREIGN KEY (offerId) REFERENCES Offer (id) ON DELETE CASCADE,
    CONSTRAINT detailId_fk FOREIGN KEY (detailId) REFERENCES Detail (id) ON DELETE CASCADE,
    CONSTRAINT offerDetailId PRIMARY KEY (
                                          offerId, detailId
        )
);

CREATE TABLE IF NOT EXISTS DetailProvider
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    contact VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS DetailProviderDetail
(
    detailProviderId INTEGER NOT NULL,
    detailId         INTEGER NOT NULL,
    CONSTRAINT detailProviderId_fk FOREIGN KEY (detailProviderId) REFERENCES DetailProvider (id) ON DELETE CASCADE,
    CONSTRAINT detailId_fk FOREIGN KEY (detailId) REFERENCES Detail (id) ON DELETE CASCADE,
    CONSTRAINT detailProviderDetailId PRIMARY KEY (
                                                   detailProviderId, detailId
        )
);

CREATE TABLE IF NOT EXISTS Client
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    phone   VARCHAR(255) NOT NULL,
    email   VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Car
(
    id            SERIAL PRIMARY KEY,
    brand         VARCHAR(255) NOT NULL,
    model         VARCHAR(255) NOT NULL,
    creation_year DATE         NOT NULL
);
CREATE TABLE IF NOT EXISTS Employee
(
    id      SERIAL PRIMARY KEY,
    name    VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    snils   VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Worker
(
    employeeId     INTEGER      NOT NULL,
    CONSTRAINT employeeId_fk FOREIGN KEY (employeeId) REFERENCES Employee (id) ON DELETE CASCADE,
    CONSTRAINT employeeId PRIMARY KEY (
                                            employeeId
        ),
    specialization VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Purchase
(
    id        SERIAL PRIMARY KEY,
    clientId  INTEGER REFERENCES Client (id) ON DELETE CASCADE         NOT NULL,
    carId     INTEGER REFERENCES Car (id) ON DELETE CASCADE            NOT NULL,
    workerId  INTEGER REFERENCES Worker (employeeId) ON DELETE CASCADE NOT NULL,
    state     VARCHAR(255)                                             NOT NULL,
    createdAt DATE                                                     NOT NULL,
    closedAt  DATE                                                     NOT NULL
);

CREATE TABLE IF NOT EXISTS OfferPurchase
(
    offerId    INTEGER NOT NULL,
    purchaseId INTEGER NOT NULL,
    CONSTRAINT offerId_fk FOREIGN KEY (offerId) REFERENCES Offer (id) ON DELETE CASCADE,
    CONSTRAINT purchaseId_fk FOREIGN KEY (purchaseId) REFERENCES Purchase (id) ON DELETE CASCADE,
    CONSTRAINT offerPurchaseId PRIMARY KEY (
                                            offerId, purchaseId
        )
);

CREATE TABLE IF NOT EXISTS Review
(
    id         SERIAL PRIMARY KEY,
    clientId   INTEGER REFERENCES Client (id) ON DELETE CASCADE NOT NULL,
    reviewText VARCHAR(255)                                     NOT NULL,
    rating     INTEGER                                          NOT NULL
        CHECK (rating >= 0 and rating <= 5)
);

CREATE TABLE IF NOT EXISTS ReviewOffer
(
    offerId  INTEGER NOT NULL,
    reviewId INTEGER NOT NULL,
    CONSTRAINT offerId_fk FOREIGN KEY (offerId) REFERENCES Offer (id) ON DELETE CASCADE,
    CONSTRAINT reviewId_fk FOREIGN KEY (reviewId) REFERENCES Review (id) ON DELETE CASCADE,
    CONSTRAINT offerReviewId PRIMARY KEY (
                                          offerId, reviewId
        )
);



CREATE TABLE IF NOT EXISTS CarClient
(
    carId    INTEGER NOT NULL,
    clientId INTEGER NOT NULL,
    CONSTRAINT carId_fk FOREIGN KEY (carId) REFERENCES Car (id) ON DELETE CASCADE,
    CONSTRAINT clientId_fk FOREIGN KEY (clientId) REFERENCES Client (id) ON DELETE CASCADE,
    CONSTRAINT carClientId PRIMARY KEY (
                                        carId, clientId
        )
);

CREATE TABLE IF NOT EXISTS Administrator
(
    employeeId     INTEGER      NOT NULL,
    CONSTRAINT employee2Id_fk FOREIGN KEY (employeeId) REFERENCES Employee (id) ON DELETE CASCADE,
    CONSTRAINT employee2Id PRIMARY KEY (
                                       employeeId
        ),
    roles      VARCHAR(255)                                       NOT NULL
);

CREATE TABLE IF NOT EXISTS AdministratorPurchase
(
    administratorId INTEGER NOT NULL,
    purchaseId      INTEGER NOT NULL,
    CONSTRAINT administratorId_fk FOREIGN KEY (administratorId) REFERENCES Administrator (employeeId) ON DELETE CASCADE,
    CONSTRAINT purchaseId_fk FOREIGN KEY (purchaseId) REFERENCES Purchase (id) ON DELETE CASCADE,
    CONSTRAINT administratorPurchaseId PRIMARY KEY (
                                                    administratorId, purchaseId
        )
);

CREATE TABLE IF NOT EXISTS Manufacturer
(
    employeeId            INTEGER REFERENCES Employee (id) ON DELETE CASCADE NOT NULL,
    detail_specialization VARCHAR(255)                                       NOT NULL
);

CREATE TABLE IF NOT EXISTS CallCenterWorker
(
    employeeId       INTEGER REFERENCES Employee (id) ON DELETE CASCADE NOT NULL,
    workingTimeStart TIME                                               NOT NULL,
    workingTimeEnd   TIME                                               NOT NULL
);

CREATE TABLE IF NOT EXISTS STO
(
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS EmployeeSTO
(
    employeeId INTEGER NOT NULL,
    STOId      INTEGER NOT NULL,
    CONSTRAINT employeeId_fk FOREIGN KEY (employeeId) REFERENCES Employee (id) ON DELETE CASCADE,
    CONSTRAINT purchaseId_fk FOREIGN KEY (STOId) REFERENCES STO (id) ON DELETE CASCADE,
    CONSTRAINT employeeSTOId PRIMARY KEY (
                                          employeeId, STOId
        )
);



